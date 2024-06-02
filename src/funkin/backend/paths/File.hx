package funkin.backend.paths;

import openfl.utils.AssetType;

class File
{
    static public function file(path:String, type:AssetType = TEXT, ?library:String):Any
        return Paths.file(path, type, library);
}