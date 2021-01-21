
import php.NativeAssocArray;
import php.NativeArray;

class ExportJsonp extends ExportJsonl
{
	override public function getFileType() {
		return 'js';
	}

	override public function header() {
		setHeader('Content-type', 'application/javascript');

		fwrite(output, getParam('callback') + "([\n");
	}

	override public function render() {
		super.render();
		fwrite(output, ",");
	}

	override public function footer() {
		fwrite(output, "null");
		fwrite(output, "]);\n");
	}
}