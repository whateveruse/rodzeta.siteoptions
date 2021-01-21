
class IblockPropertiesIterator extends CDBResultIterator {

	var propsFilter: Map<Int, Bool>;
	var usePropsFilter: Bool;

	public function new(result:CDBResult, propsFilter: Map<Int, Bool>) {
        super(result);
        this.propsFilter = propsFilter;
        usePropsFilter = Lambda.count(propsFilter) > 0;
    }

    override function hasNext() {
    	var result = true;
    	while (true) {
	    	result = super.hasNext();
	    	if (!result) {
	    		break;
	    	}
	    	if (!usePropsFilter) {
	    		break;
	    	}
	    	if (propsFilter.exists(Std.parseInt(current['ID'])))
	    	{
	    		break;
	    	}
		}
        return result;
    }

    override public function next() {
        super.next();

        if (current['PROPERTY_TYPE'] == 'L') {
            var res = CIBlockProperty.GetPropertyEnum(
                Std.parseInt(current['ID']),
                Lib.associativeArrayOfHash(['sort' => 'asc']),
                Lib.associativeArrayOfHash(['IBLOCK_ID' => current['IBLOCK_ID']])
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
        }

		return current;
    }

	public static function fromCsvRow(row:Map<String, String>) {
		var result = new NativeArray();
		if (row['PROPERTY_TYPE'] == 'L') {
			var enums = new Map<String, Dynamic>();
			var ids = row['VALUES.ID'].split("\n");
			var values = row['VALUES'].split("\n");
			var def = row['VALUES.DEF'].split("\n");
			var sort = row['VALUES.SORT'].split("\n");
			var xmlIds = row['VALUES.XML_ID'].split("\n");
			for (i in 0...values.length) {
				var enumValue = new NativeArray();
				enumValue['VALUE'] = values[i];
				enumValue['ID'] = (ids[i] != '' && ids[i] != '0')? ids[i] : ('n' + i);
				enumValue['DEF'] = def[i];
				enumValue['SORT'] = sort[i];
				enumValue['XML_ID'] = xmlIds[i];
				enums[enumValue['ID']] = enumValue;
			}
			result['VALUES'] = Lib.associativeArrayOfHash(enums);
		}
		for (code in row.keys()) {
			if (code.substr(0, 6) != 'VALUES'
					&& code != 'TIMESTAMP_X') {
				result[code] = row[code];
			}
		}
		return result;
	}
}
