package funkin.backend.paths;

import openfl.media.Sound;

class Music
{
    static public function file(path:String, ?library:String = null):Sound
        return Paths.music(path, library);

    static public function def():Sound
        return file('freakyMenu');
}