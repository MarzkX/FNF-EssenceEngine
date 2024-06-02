package funkin.backend.paths;

import openfl.media.Sound as OpenFlSound;

class Sound
{
    static public function file(path:String, ?library:String = null):OpenFlSound
        return Paths.sound(path, library);

    static public function random(path:String, min:Int, max:Int, ?library:String = null):OpenFlSound
        return Paths.soundRandom(path, min, max, library);
}