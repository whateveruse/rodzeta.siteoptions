
extern class CIBlockProperty {
	public var LAST_ERROR:String;

	public function new();
    public static function GetList(order:PhpAssocArrayString, filter:PhpAssocArrayString):CDBResult;
    public static function GetPropertyEnum(id:Int, order:PhpAssocArrayString, filter:PhpAssocArrayString):CDBResult;
    public function Add(fields:NativeArray):EitherType<Bool, Int>;
    public function Update(id:Int, fields:NativeArray):Bool;
}
