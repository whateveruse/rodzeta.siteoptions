
import php.NativeAssocArray;
import php.NativeArray;

class ExportCsv implements IExport
{
	public var item:NativeAssocArray<String>;
	public var convertedItem:NativeAssocArray<String>;
	public var numExported:Int;
	public var numTotal:Int;
	public var fileId:String;
	public var output:Dynamic;
	public var select:NativeArray;

	public var separator = ',';
	public var enclosure = '"';
	public var useFormatting:Bool = false;

	public function new(useFormatting:Bool = false) {
		this.useFormatting = useFormatting;
	}

	public function getFileType() {
		return 'csv';
	}

	public function getOutputPath():String {
		return _SERVER['DOCUMENT_ROOT'] + '/upload/tmp/';
	}

	public function getFileName():String {
		return getOutputPath() + fileId + '.' + getFileType();
	}

	public function init(fileId:String, select:NativeArray) {
		this.fileId = fileId;
        this.select = select;

		var fname = getFileName();
	    output = fopen(fname, 'w');
        if (!output) {
        	throw "Cant't create file " + fname;
        }
	}

    public function formatCsvValue(row:NativeArray):NativeArray {
        if (!useFormatting) {
            return row;
        }
        var result:NativeArray = new NativeArray();
        for (col in row) {
        	array_push(result, "\n" + col);
        }
        return result;
    }

	public function header() {
		setHeader('Content-type', 'text/plain');

		fputcsv(output, convertToUtf8(formatCsvValue(select)), separator, enclosure);
	}

	//NOTE конвертация значений свойств в нужное представление
	public function convert() {
		convertedItem = item;
	}

    public static function filterValues(item:NativeAssocArray<String>, select:NativeArray):NativeArray {
    	//!!!example NativeArray
    	//var a = new NativeArray();
		//a['hello'] = 'world';
		//array_push(a, 123);
		//unset(a['hello']);
		//...

    	var result:NativeArray = new NativeArray();
    	for (code in select) {
    		array_push(result, isset(item[code]) ? item[code] : '');
        }
        return result;
    }

	//NOTE вывод значения в заданом формате
	public function render() {
		var line = filterValues(convertedItem, select);
		fputcsv(output, convertToUtf8(formatCsvValue(line)), separator, enclosure);
	}

	public function footer() {
	}

	public function done() {
		fclose(output);
	}
}