
import php.NativeAssocArray;
import php.NativeArray;

interface IExport
{
	public var item:NativeAssocArray<String>;
	public var convertedItem:NativeAssocArray<String>;
	public var numExported:Int;
	public var numTotal:Int;
	public var fileId:String;
	public var output:Dynamic;
	public var select:NativeArray;

	public function getFileType():String;

	public function getOutputPath():String;

	public function getFileName():String;

	public function init(fileId:String, select:NativeArray):Void;

	public function header():Void;

	public function convert():Void;

	public function render():Void;

	public function footer():Void;

	public function done():Void;
}