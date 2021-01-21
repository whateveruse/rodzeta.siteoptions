
extern class CIBlockType {
    public static function GetList(order:PhpAssocArrayString, filter:PhpAssocArrayString):CDBResult;
	public static function GetByIDLang(id:String, lang:String, bFindAny:Bool = true):PhpAssocArrayString;
}
