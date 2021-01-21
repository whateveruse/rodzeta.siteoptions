
class Tools
{
    public static var encodingResult:Bool = true;
    public static var processor:Dynamic;

    public static inline function getParam(name:String):String
    {
        return _REQUEST[name];
    }

    public static inline function getParams(name:String):Array<String>
    {
        return Lib.toHaxeArray(_REQUEST[name])
            .map(function (v:String) return v);
    }

    public static inline function redirect(url:String) {
        header('Location: ' + url);
    }

    public static inline function setHeader(h:String, v:String) {
        header('$h: $v');
    }

    public static function setReturnCode(r:Int) {
        var code:String;
        switch (r) {
            case 100:
                code = "100 Continue";
            case 101:
                code = "101 Switching Protocols";
            case 200:
                code = "200 OK";
            case 201:
                code = "201 Created";
            case 202:
                code = "202 Accepted";
            case 203:
                code = "203 Non-Authoritative Information";
            case 204:
                code = "204 No Content";
            case 205:
                code = "205 Reset Content";
            case 206:
                code = "206 Partial Content";
            case 300:
                code = "300 Multiple Choices";
            case 301:
                code = "301 Moved Permanently";
            case 302:
                code = "302 Found";
            case 303:
                code = "303 See Other";
            case 304:
                code = "304 Not Modified";
            case 305:
                code = "305 Use Proxy";
            case 307:
                code = "307 Temporary Redirect";
            case 400:
                code = "400 Bad Request";
            case 401:
                code = "401 Unauthorized";
            case 402:
                code = "402 Payment Required";
            case 403:
                code = "403 Forbidden";
            case 404:
                code = "404 Not Found";
            case 405:
                code = "405 Method Not Allowed";
            case 406:
                code = "406 Not Acceptable";
            case 407:
                code = "407 Proxy Authentication Required";
            case 408:
                code = "408 Request Timeout";
            case 409:
                code = "409 Conflict";
            case 410:
                code = "410 Gone";
            case 411:
                code = "411 Length Required";
            case 412:
                code = "412 Precondition Failed";
            case 413:
                code = "413 Request Entity Too Large";
            case 414:
                code = "414 Request-URI Too Long";
            case 415:
                code = "415 Unsupported Media Type";
            case 416:
                code = "416 Requested Range Not Satisfiable";
            case 417:
                code = "417 Expectation Failed";
            case 500:
                code = "500 Internal Server Error";
            case 501:
                code = "501 Not Implemented";
            case 502:
                code = "502 Bad Gateway";
            case 503:
                code = "503 Service Unavailable";
            case 504:
                code = "504 Gateway Timeout";
            case 505:
                code = "505 HTTP Version Not Supported";
            default:
                code = Std.string(r);
        }
        header('HTTP/1.1 ' + code, true, r);
    }

    public static inline function getOutputEncoding()
    {
        return (encodingResult && !defined('BX_UTF'))? 'UTF-8' : 'windows-1251';
    }

    public static inline function convertToUtf8(row:Any):Any {
        if (encodingResult && !defined('BX_UTF')) {
            row = Encoding.convertEncoding(row, 'windows-1251', 'UTF-8');
        }
        return row;
    }

    public static inline function convertToWin(row:Any):Any {
        if (encodingResult && !defined('BX_UTF')) {
            row = Encoding.convertEncoding(row, 'UTF-8', 'windows-1251');
        }
        return row;
    }

    public inline static function convertData(type:String, item:Dynamic):Dynamic {
        //TODO!!! use export class convert
        return item;
    }

    public static function export(fileId:String, items:Iterator<Map<String, String>>, select:Array<String>):String {
        processor.init(fileId, Lib.toPhpArray(select));
        processor.numExported = 0;
        processor.numTotal = 0;

        processor.header();

        for (item in items) {
            processor.item = Lib.associativeArrayOfHash(item);

            processor.convertedItem = [];
            processor.convert();

            if (count(processor.convertedItem) > 0) {
                processor.render();
                processor.numExported++;
            }
            processor.numTotal++;
        }

        processor.footer();

        processor.done();

        return processor.getFileName();
    }

    /*
    public static function initEnvFromConfigParam(name:String) {
        var conf:Any = Configuration.getValue(name);
        if (!is_array(conf)) {
            return;
        }
        var config:Map<String, String> = Lib.hashOfAssociativeArray(conf);
        for (k in config.keys()) {
            if (is_string(config[k])) {
                _ENV[k] = config[k];
            }
        }
    }
    */

    public static function fromAbsToRelPath(fname:String, basePath:String = '') {
        if (basePath == '') {
            basePath = _SERVER['DOCUMENT_ROOT'];
        }
        var l = basePath.length;
        if (fname.substr(0, l) == basePath) {
            return fname.substr(l);
        }
        return fname;
    }
}
