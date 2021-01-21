
// https://haxe.org/blog/importhx-intro/
// https://haxe.org/manual/type-system-import.html
// import haxe.extern.EitherType; // example https://gist.github.com/RealyUniqueName/e0c6a3c051c790c0cfae58eeebdd7fae

import haxe.extern.EitherType;
import haxe.io.Path;

import php.Lib;
import php.Web;
import php.Global.*;
import php.SuperGlobal.*;
import php.Syntax;
import php.NativeArray;

import GlobalPhpFunctions.*;
import Tools.*;

import Bitrix;
import Bitrix.sectionIdsPath;
import Bitrix.iblockSections;
import Bitrix.iblockProperties;
import Bitrix.iblockElements;
import Bitrix.iblocks;
import Bitrix.iblocksFormElementFields;
import Bitrix.iblockTypes;
import Bitrix.users;
import Bitrix.userFields;
import Bitrix.updateIblockPropertiesFromCsv;

import ExportCsv;
import ExportYml;
import ExportJsonl;
import ExportJson;
import ExportJsonp;
