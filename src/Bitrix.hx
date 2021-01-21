import php.NativeAssocArray;
import php.NativeArray;

typedef PhpAssocArrayString = NativeAssocArray<String>;
typedef PhpAssocArrayObject = NativeAssocArray<Dynamic>;

class Bitrix {
    public static function iblockProperties(id:Int, ?filterSectionIds: Array<Int>) {
        var res = CIBlockProperty.GetList(
            Lib.associativeArrayOfHash(['sort' => 'asc', 'name' => 'asc']),
            Lib.associativeArrayOfHash(['ACTIVE' => 'Y', 'IBLOCK_ID' => id])
        );

        // init property ids for selected sections
        var propsForSections = new Map<Int, Bool>();
        for (sectionId in filterSectionIds) {
            for (propId in iblockPropertiesForSection(id, sectionId)) {
                propsForSections.set(Std.parseInt(propId), true);
            }
        }

        return new IblockPropertiesIterator(res, propsForSections);
    }

    public static function sectionIdsPath(allSections:Map<Int, Map<String, String>>, section:Map<String, String>, path:Array<Int>) {
        path.push(Std.parseInt(section['ID']));
        var parentSection = section['IBLOCK_SECTION_ID'];
        if (parentSection == null) {
            return path;
        }
        var parentId = Std.parseInt(parentSection);
        if (!allSections.exists(parentId)) {
            path.push(parentId);
            return path;
        }
        return sectionIdsPath(allSections, allSections.get(parentId), path);
    }

    public static function iblockPropertiesForSection(iblockId:Int, sectionId:Int = 0):Array<String> {
        var result = [];
        for (id in Lib.hashOfAssociativeArray(CIBlockSectionPropertyLink.GetArray(iblockId, sectionId)).keys()) {
            result.push(id);
        }
        return result;
    }

    public static function iblockSections(id:Int) {
        var res = CIBlockSection.GetTreeList(
            Lib.associativeArrayOfHash(['IBLOCK_ID' => id]),
            Lib.toPhpArray(['UF_*'])
        );
        var sections:Map<Int, Map<String, String>> = new Map<Int, Map<String, String>>();
        for (item in new ArrayOrStringValuesIterator(res)) {
            sections.set(Std.parseInt(item['ID']), item);
        }
        for (sectionId in sections.keys()) {
            var section = sections.get(sectionId);
            section['NAME'] = StringTools.trim(section['NAME']);
            section['NAME_LEVEL'] = php.Global.str_repeat(' . ', Std.parseInt(section['DEPTH_LEVEL']) - 1) + section['NAME'];
            var idsPath = sectionIdsPath(sections, section, []);
            idsPath.reverse();
            section['PATH'] = idsPath.join(',');
            var namesPath:Array<String> = [];
            for (sectionId in idsPath) {
                namesPath.push(sections.get(sectionId)['NAME']);
            }
            section['NAME_PATH'] = namesPath.join(' / ');
            section['PROPERTIES'] = iblockPropertiesForSection(id, sectionId).join("\n");
            sections.set(sectionId, section);
        }
        return sections.iterator();
    }

    public static function iblockElements(id:Int, select:Array<String>, propsData:Map<String, Map<String, String>>) {
        var res = CIBlockElement.GetList(
            Lib.associativeArrayOfHash(['SORT' => 'ASC']),
            Lib.associativeArrayOfHash(['IBLOCK_ID' => id]),
            false,
            false,
            Lib.toPhpArray([])
        );
        return new CDBResultElementIterator(res, select, propsData);
    }

    public static function iblocks() {
        var res = CIBlock.GetList(
            Lib.associativeArrayOfHash(['sort' => 'asc', 'name' => 'asc']),
            Lib.associativeArrayOfHash(['' => ''])
        );
        return new IblockIterator(res);
    }

    public static function users() {
        var by = 'timestamp_x';
        var order = 'desc';
        var res = CUser.GetList(
            by,
            order,
            Lib.associativeArrayOfHash(['' => '']),
            Lib.associativeArrayOfHash(['SELECT' => Lib.toPhpArray(['UF_*'])])
        );
        return new ArrayOrStringValuesIterator(res);
    }

    public static function propertyNameWithCode(name:String, propCodes:Map<String, String>):String {
        if (name.substr(0, 9) != 'PROPERTY_') {
            return name;
        }
        return name.substr(0, 9) + propCodes[name.substr(9)];
    }

    public static function iblocksFormElementFields(id:Int) {
        var propCodes = new Map<String, String>();
        for (prop in iblockProperties(id)) {
            propCodes.set(prop['ID'], prop['CODE']);
        }
        var v = CUserOptions.GetOption('form', 'form_element_' + id);
        var s:String = v['tabs'];
        var result:Array<Map<String, String>> = [];
        for (tab in s.split('--;--')) {
            var i = 0;
            for (fields in tab.split('--,--')) {
                var v = fields.split('--#--');
                result.push(i == 0 ? [
                'TAB_NAME' => v[0],
                'FIELD_NAME' => '',
                'TITLE' => v[1],
                ] : [
                'TAB_NAME' => '',
                'FIELD_NAME' => propertyNameWithCode(v[0], propCodes),
                'TITLE' => v[1]
                ]);
                i++;
            }
        }
        return result.iterator();
    }

    public static function userFields(lang:String = 'ru') {
        var res = CUserTypeEntity.GetList(
            Lib.associativeArrayOfHash(['ENTITY_ID' => 'ASC', 'SORT' => 'ASC']),
            Lib.associativeArrayOfHash(['LANG' => lang])
        );
        return new UserTypeEntityIterator(res);
    }

    public static function iblockTypes() {
        var res = CIBlockType.GetList(
            Lib.associativeArrayOfHash(['sort' => 'asc', 'name' => 'asc']),
            Lib.associativeArrayOfHash(['' => ''])
        );
        return new IblockTypesIterator(res);
    }

    public static function updateIblockPropertiesFromCsv(iblockId:Int, srcName:String) {
        var currentProps = new Map<String, Map<String, String>>();
        for (prop in iblockProperties(iblockId)) {
            currentProps[prop['CODE']] = prop;
        }
        var csv = new CsvReader(_SERVER['DOCUMENT_ROOT'] + srcName);
        var i = 0;
        for (line in csv) {
            i++;
            if (i == 1) {
                continue;
            }
			var row = csv.getRow();
			var prop = IblockPropertiesIterator.fromCsvRow(row);
			var mProp = new CIBlockProperty();
            if (currentProps.exists(row['CODE'])) {
				var res = mProp.Update(Std.parseInt(prop['ID']), prop);
				Lib.println('UPDATE;OK;' + prop['ID']);
            } else {
            	prop['IBLOCK_ID'] = iblockId;
				var res = mProp.Add(prop);
				if (res == false) {
					Lib.println('ADD;ERROR;' + mProp.LAST_ERROR);
				} else {
					Lib.println('ADD;OK;' + res);
				}
            }
        }
    }
}
