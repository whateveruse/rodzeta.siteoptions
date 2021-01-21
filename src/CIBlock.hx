
import Bitrix;

extern class CIBlock {
    public static function GetList(order:PhpAssocArrayString, filter:PhpAssocArrayString, bIncCnt:Bool = false):CDBResult;
}
