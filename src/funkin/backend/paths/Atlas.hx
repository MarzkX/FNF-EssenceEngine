package funkin.backend.paths;

import funkin.backend.Paths;
import flixel.graphics.frames.FlxAtlasFrames;

@:access(funkin.backend.Paths)
class Atlas
{
    static public function sparrow(path:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames
        return Paths.getSparrowAtlas(path, library, allowGPU);

    static public function packer(path:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames
        return Paths.getPackerAtlas(path, library, allowGPU);

    static public function aseprite(path:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames
        return Paths.getAsepriteAtlas(path, library, allowGPU);

    static public function file(path:String, ?library:String = null, ?allowGPU:Bool = true):FlxAtlasFrames
        return Paths.getAtlas(path, library, allowGPU);
}