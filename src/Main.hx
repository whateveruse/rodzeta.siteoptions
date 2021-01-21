
class Main {

    inline static var ID = 'rodzeta.siteoptions';

    static function usersFromRequest() {
        var select = [
            'ID',
            'LID',
            'XML_ID',
            'TIMESTAMP_X',
            'LOGIN',
            'ACTIVE',
            'TITLE',
            'NAME',
            'LAST_NAME',
            'SECOND_NAME',
            'EMAIL',
            'PERSONAL_PROFESSION',
            'PERSONAL_WWW',
            'PERSONAL_ICQ',
            'PERSONAL_GENDER',
            'PERSONAL_BIRTHDAY',
            'PERSONAL_PHOTO',
            'PERSONAL_PHONE',
            'PERSONAL_FAX',
            'PERSONAL_MOBILE',
            'PERSONAL_PAGER',
            'PERSONAL_STREET',
            'PERSONAL_MAILBOX',
            'PERSONAL_CITY',
            'PERSONAL_STATE',
            'PERSONAL_ZIP',
            'PERSONAL_COUNTRY',
            'PERSONAL_NOTES',
            'WORK_COMPANY',
            'WORK_DEPARTMENT',
            'WORK_POSITION',
            'WORK_WWW',
            'WORK_PHONE',
            'WORK_FAX',
            'WORK_PAGER',
            'WORK_STREET',
            'WORK_MAILBOX',
            'WORK_CITY',
            'WORK_STATE',
            'WORK_ZIP',
            'WORK_COUNTRY',
            'WORK_PROFILE',
            'WORK_LOGO',
            'WORK_NOTES',
        ];
        var fields = getParams('select');
        if (fields.length > 0) {
            select = select.concat(fields);
        }
        return export(ID + '_users', users(), select);
    }

    static function iblocksFromRequest() {
        var select = [
            'ID',
            'LID',
            'CODE',
            'XML_ID',
            'IBLOCK_TYPE_ID',
            'TIMESTAMP_X',
            'NAME',
            'ACTIVE',
            'SORT'
        ];
        return export(ID + '_iblocks', iblocks(), select);
    }

    static function iblockSectionsFromRequest() {
        var select = [
            'ID',
            'CODE',
            'XML_ID',
            'NAME',
            'DEPTH_LEVEL',
            'NAME_LEVEL',
            'PATH',
            'NAME_PATH',
            'IBLOCK_SECTION_ID',
            'IBLOCK_ID',
            'TIMESTAMP_X',
            'SORT',
            'ACTIVE',
            'PROPERTIES'
        ];
        var id = getParam('id');
        var fields = getParams('select');
        if (fields.length > 0) {
            select = select.concat(fields);
        }
        return export(ID + '_iblock_sections_' + id, iblockSections(Std.parseInt(id)), select);
    }

    static function iblockElementsFromRequest() {
        var id = getParam('id');
        var iblockId = Std.parseInt(id);
        var select = [
            'ID',
            'XML_ID',
            'IBLOCK_ID',
            'ACTIVE',
            'NAME',
            'PREVIEW_PICTURE',
            'DETAIL_PICTURE',
            'PREVIEW_TEXT',
            'DETAIL_TEXT',
            'CODE',
            'SECTIONS', // calculated element sections ids
            'TIMESTAMP_X',
            'ACTIVE_FROM',
            'ACTIVE_TO',
            'IBLOCK_SECTION_ID',
        ];
        var allPropCodes:Array<String> = [];
        var propsData = new Map<String, Map<String, String>>();
        for (prop in iblockProperties(iblockId)) {
            allPropCodes.push(prop['CODE']);
            propsData.set(prop['CODE'], prop);
        }
        var props = getParams('select');
        if (props.length > 0) {
            select = select.concat(props);
        } else {
            select = select.concat(allPropCodes);
        }
        return export(ID + '_iblock_elements_' + id, iblockElements(iblockId, select, propsData), select);
    }

    static function iblockPropertiesFromRequest() {
        var select = [
            'ID',
            'XML_ID',
            'SORT',
            'NAME',
            'CODE',
            'PROPERTY_TYPE',

            'VALUES',
            'VALUES.XML_ID',
            'VALUES.SORT',
            'VALUES.ID',
            'VALUES.DEF',

            'USER_TYPE',
            'MULTIPLE',
            'IS_REQUIRED',
            'TIMESTAMP_X',
            'LIST_TYPE',
            'HINT',
        ];
        var id = getParam('id');
        var filterSections = getParams('section_id');
        var filterSectionsIds:Array<Int> = [];
        var filterPrefix = '';
        if (filterSections.length > 0) {
            for (section in filterSections) {
                filterSectionsIds.push(Std.parseInt(section));
            }
            filterPrefix = '_sections_' + filterSections.join(',');
        }

        return export(
            ID + '_iblock_properties_' + id + filterPrefix,
            iblockProperties(Std.parseInt(id), filterSectionsIds),
            select
        );
    }

    static function iblocksFormElementFromRequest() {
        var select = [
            'TAB_NAME',
            'FIELD_NAME',
            'TITLE',
        ];
        var id = getParam('id');
        return export(ID + '_iblock_form_element_' + id, iblocksFormElementFields(Std.parseInt(id)), select);
    }

    static function userFieldsFromRequest() {
        var select = [
            'ID',
            'ENTITY_ID',
            'FIELD_NAME',
            'USER_TYPE_ID',

            'VALUES',
            'VALUES.XML_ID',
            'VALUES.SORT',
            'VALUES.ID',
            'VALUES.DEF',

            'XML_ID',
            'SORT',
            'MULTIPLE',
            'MANDATORY',
            'SHOW_FILTER',
            'SHOW_IN_LIST',
            'EDIT_IN_LIST',
            'IS_SEARCHABLE',
            'SETTINGS_DESCRIPTION',
            'SETTINGS_VALUE',
            'EDIT_FORM_LABEL',
            'LIST_COLUMN_LABEL',
            'LIST_FILTER_LABEL',
            'ERROR_MESSAGE',
            'HELP_MESSAGE',
        ];
        return export(ID + '_user_fields_', userFields(), select);
    }

    static function iblockTypesFromRequest() {
        var select = [
            'ID',
            'SECTIONS',
            'EDIT_FILE_BEFORE',
            'EDIT_FILE_AFTER',
            'IN_RSS',
            'SORT',
            'LID',
            'NAME',
            'SECTION_NAME',
            'ELEMENT_NAME',
        ];
        return export(ID + '_iblock_types_', iblockTypes(), select);
    }

    static function main() {
        setHeader('Access-Control-Allow-Origin', '*');
        CModule.IncludeModule('iblock');

        var outFileName = '';

        if (getParam('encoding') == '0') {
            encodingResult = false;
        } else {
            encodingResult = true;
        }

        if (getParam('processor') != null) {
            processor = Syntax.construct('\\RodzetaSiteoptions\\Export' + Syntax.code('ucfirst({0})', getParam('processor')));
        } else {
            processor = new ExportCsv(getParam('format') == '1');
        }

        if (getParam('import') == '1') {
            switch (getParam('entity')) {
                case 'iblock_properties':
                    updateIblockPropertiesFromCsv(Std.parseInt(getParam('id')), getParam('src'));
            }
        } else {
            switch (getParam('entity')) {
                case 'iblock_properties':
                    outFileName = iblockPropertiesFromRequest();
                case 'iblock_sections':
                    outFileName = iblockSectionsFromRequest();
                case 'iblock_elements':
                    outFileName = iblockElementsFromRequest();
                case 'iblock':
                    outFileName = iblocksFromRequest();
                case 'iblock_form_element':
                    outFileName = iblocksFormElementFromRequest();
                case 'iblock_types':
                    outFileName = iblockTypesFromRequest();
                case 'user':
                    outFileName = usersFromRequest();
                case 'user_fields':
                    outFileName = userFieldsFromRequest();
            }
            if (outFileName != '') {
                if (getParam('output') == '1') {
                    setHeader('Content-Disposition', 'attachment; filename="' + Path.withoutDirectory(outFileName) + '"');
                    readfile(outFileName);
                } else {
                    // convert to url
                    outFileName = fromAbsToRelPath(outFileName);
                    redirect(outFileName);
                }
            } else {
                setReturnCode(404);
            }
        }
    }
}
