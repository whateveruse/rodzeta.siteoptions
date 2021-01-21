
class CsvReader {
    var fin:Dynamic;
    var current:Array<String>;
    var isEmpty:Bool;
    var isFirstLine:Bool;
    var length:Int;
    var separator:String;
    var enclosure:String;
    var header:Array<String>;

    public function new(fname:String, length = 10000, separator = ',', enclosure = '"') {
        fin = fopen(fname, 'r');
        isEmpty = false;
        isFirstLine = true;
        current = [];
        header = [];
        this.separator = separator;
        this.enclosure = enclosure;
        this.length = length;
    }

    public function hasNext() {
        var row:Dynamic;
        if (!fin) {
            isEmpty = true;
            row = false;
        } else {
            row = fgetcsv(fin, length, separator, enclosure);
            isEmpty = php.Syntax.strictEqual(row, false);
        }
        if (!isEmpty) {
			var tmp = Lib.toHaxeArray(convertToWin(row));
			current = [];
			for (v in tmp) {
				current.push(v);
			}
            if (isFirstLine) {
                header = current;
                isFirstLine = false;
            }
        } else if (fin) {
            fclose(fin);
        }
        return !isEmpty;
    }

    public function next() {
        return current;
    }

    public function getHeader():Array<String> {
        return header;
    }

    public function getRow():Map<String, String> {
        var row = new Map<String, String>();
        for (i in 0...header.length) {
            row[header[i]] = current[i];
        }
        return row;
    }
}
