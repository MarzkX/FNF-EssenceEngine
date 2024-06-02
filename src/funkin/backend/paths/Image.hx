package funkin.backend.paths;

import flixel.graphics.FlxGraphic;
import funkin.backend.Paths;

@:access(funkin.backend.Paths)
class Image
{
    static public function file(path:String, ?library:String = null, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image(path, library, allowGPU);

    static public function stage(path:String, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image('stages/$path', null, allowGPU);

    static public function character(path:String, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image('characters/$path', null, allowGPU);

    static public function ui(path:String, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image(PathStr.UI_PATH + path, null, allowGPU);

    static public function game(path:String, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image(PathStr.GAME_PATH + path, null, allowGPU);

    static public function menu(path:String, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image(PathStr.MENU_PATH + path, null, allowGPU);

    static public function editor(path:String, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image(PathStr.EDITOR_PATH + path, null, allowGPU);

    static public function award(path:String, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image(PathStr.AWARD_PATH + path, null, allowGPU);

    static public function dialogue(path:String, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image(PathStr.DIALOGUE_PATH + path, null, allowGPU);

    static public function difficulty(path:String, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image(PathStr.DIFFICULTY_PATH + path, null, allowGPU);

    static public function note(path:String, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image(PathStr.NOTE_PATH + path, null, allowGPU);

    static public function option(path:String, ?allowGPU:Bool = true):FlxGraphic
        return Paths.image(PathStr.OPTIONS_PATH + path, null, allowGPU);

    static public function def_bg():FlxGraphic
        return menu('menuDesat');
}