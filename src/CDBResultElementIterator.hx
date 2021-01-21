class CDBResultElementIterator {
    var result:CIBlockResult;
    var current:Map<String, String>;
    var isEmpty:Bool;
    var select:Array<String>;
    var propsData:Map<String, Map<String, String>>;

    public function new(result:CIBlockResult, select:Array<String>, propsData:Map<String, Map<String, String>>) {
        this.result = result;
        isEmpty = false;
        current = ['' => ''];
        this.select = select;
        this.propsData = propsData;
    }

    public function hasNext() {
        var row = result.GetNextElement();
        isEmpty = php.Syntax.strictEqual(row, false);
        if (!isEmpty) {
            current = Lib.hashOfAssociativeArray(convertData('iblock_elements', row.GetFields()));
            for (code in current.keys()) {
                var fieldValue = current[code];
                if (code == 'PREVIEW_PICTURE' || code == 'DETAIL_PICTURE') {
                    fieldValue = CFile.GetPath(fieldValue);
                }
                current.set(code, fieldValue);
            }

            var sections = [];
            for (section in new CDBResultIterator(row.GetGroups())) {
                sections.push(section['ID']);
            }
            current.set('SECTIONS', sections.join("\n"));

            var props = convertData('iblock_elements', row.GetProperties());
            for (code in select) {
                if (array_key_exists(code, props)) {
                    var prop:PhpAssocArrayObject = props[code];
                    var propValue:Array<String> = is_array(prop['VALUE']) ?
                    Lib.toHaxeArray(prop['VALUE']) : [prop['VALUE']];
                    var propData = propsData.get(code);
                    // fix for file properties
                    if (propData.get('PROPERTY_TYPE') == 'F') {
                        for (i in 0...propValue.length) {
                            propValue[i] = CFile.GetPath(propValue[i]);
                        }
                    }
                    current.set(code, propValue.join("\n"));
                }
            }
        }
        return !isEmpty;
    }

    public function next() {
        // merge fields and props
        return current;
    }
}

