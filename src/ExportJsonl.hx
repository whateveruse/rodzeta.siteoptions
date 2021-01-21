
import php.NativeAssocArray;
import php.NativeArray;

class ExportJsonl extends ExportCsv
{
	override public function getFileType() {
		return 'jsonl';
	}

	override public function header() {
		setHeader('Content-type', 'text/plain');
	}

	override public function render() {
		fwrite(output, Json.encode(convertedItem) + "\n");
	}

	override public function footer() {
	}
}