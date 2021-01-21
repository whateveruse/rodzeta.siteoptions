
@:phpGlobal
extern class GlobalPhpFunctions {

    static function readfile(path:String):Void;

    static function fputcsv(fout:Dynamic, line:NativeArray, separator:String = ';', enclosure:String = '"'):Int;

	static function fgetcsv(fin:Dynamic, length:Int, separator:String = ';', enclosure:String = '"'):String;
}
