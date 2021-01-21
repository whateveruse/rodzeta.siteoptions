class UserTypeEntityIterator extends CDBResultIterator {
    override public function hasNext() {
        var row = result.GetNext();
        isEmpty = php.Syntax.strictEqual(row, false);
        if (!isEmpty) {
            var tmp:Map<String, Dynamic> = Lib.hashOfAssociativeArray(row);
            current = new Map<String, String>();
            for (code in tmp.keys()) {
                if (code == 'SETTINGS') {
                    var settings:Map<String, Dynamic> = Lib.hashOfAssociativeArray(tmp[code]);
                    var descrs = [];
                    var values = [];
                    for (settingCode in settings.keys()) {
                        var settingValue:Dynamic = settings[settingCode];
                        if (is_array(settingValue)) {
                            settingValue = implode(';', settingValue);
                        }
                        descrs.push(settingCode);
                        values.push(settingValue);
                    }
                    current.set('SETTINGS_DESCRIPTION', descrs.join("\n"));
                    current.set('SETTINGS_VALUE', values.join("\n"));
                } else if (tmp['USER_TYPE_ID'] == 'enumeration') {
                    var res = CUserFieldEnum.GetList(
                        Lib.associativeArrayOfHash(['sort' => 'asc']),
                        Lib.associativeArrayOfHash(['USER_FIELD_ID' => tmp['ID']])
                    );
                    var ids = [];
                    var values = [];
                    var def = [];
                    var sort = [];
                    var xmlIds = [];
                    for (enumValue in new CDBResultIterator(res)) {
                        ids.push(enumValue['ID']);
                        values.push(enumValue['VALUE']);
                        def.push(enumValue['DEF']);
                        sort.push(enumValue['SORT']);
                        xmlIds.push(enumValue['XML_ID']);
                    }
                    current['VALUES'] = values.join("\n");
                    current['VALUES.ID'] = ids.join("\n");
                    current['VALUES.DEF'] = def.join("\n");
                    current['VALUES.SORT'] = sort.join("\n");
                    current['VALUES.XML_ID'] = xmlIds.join("\n");
                    current.set(code, tmp[code]);
                } else {
                    current.set(code, tmp[code]);
                }
            }
        }
        return !isEmpty;
    }
}
