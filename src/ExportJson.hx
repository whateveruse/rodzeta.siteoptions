
import php.NativeAssocArray;
import php.NativeArray;

class ExportJson extends ExportJsonl
{
	override public function getFileType() {
		return 'json';
	}

	override public function header() {
		setHeader('Content-type', 'application/json');

		fwrite(output, "[\n");
	}

	override public function render() {
		super.render();
		fwrite(output, ",");
	}

	override public function footer() {
		fwrite(output, "null");
		fwrite(output, "]\n");
	}
}