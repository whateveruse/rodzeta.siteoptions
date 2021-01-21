
class ArrayOrStringValuesIterator extends CDBResultIterator {
    override public function hasNext() {
        var row = result.GetNext();
        isEmpty = php.Syntax.strictEqual(row, false);
        if (!isEmpty) {
            var tmp:Map<String, Dynamic> = Lib.hashOfAssociativeArray(row);
            current = new Map<String, String>();
            for (code in tmp.keys()) {
                var fieldValue:Dynamic = tmp[code];
                if (is_array(fieldValue)) {
                    fieldValue = implode("\n", fieldValue);
                }
                current.set(code, fieldValue);
            }
        }
        return !isEmpty;
    }
}
