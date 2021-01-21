
import php.Lib;

class CDBResultIterator {
    var result:CDBResult;
    var current:Map<String, String>;
    var isEmpty:Bool;

    public function new(result:CDBResult) {
        this.result = result;
        isEmpty = false;
        current = ['' => ''];
    }

    public function hasNext() {
        var row = result.GetNext();
        isEmpty = php.Syntax.strictEqual(row, false);
        if (!isEmpty) {
            current = Lib.hashOfAssociativeArray(row);
        }
        return !isEmpty;
    }

    public function next() {
        return current;
    }
}
