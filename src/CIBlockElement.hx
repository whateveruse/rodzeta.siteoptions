
import Bitrix;

extern class CIBlockElement {
    public static function GetList(order:PhpAssocArrayString, filter:PhpAssocArrayString,
        arGroupBy:Bool, arNavStartParams:Bool, select:PhpAssocArrayString):CIBlockResult;
}
