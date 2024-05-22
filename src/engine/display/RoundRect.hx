package engine.display;

import flixel.util.FlxSpriteUtil;

class RoundRect
{
    public static function rect(spr:FlxSprite, width:Float, height:Float, elW:Float, elH:Float, color:FlxColor):FlxSprite
    {
        return FlxSpriteUtil.drawRoundRect(new FlxSprite().makeGraphic(Std.int(width), 
            Std.int(height), 0x00000000), 0, 0, width, height, elW, elH, color);
    }

    public static function rectComplex(spr:FlxSprite, width:Float, height:Float, topL:Float, topR:Float, downL:Float, downR:Float, color:FlxColor):FlxSprite
    {
        return FlxSpriteUtil.drawRoundRectComplex(new FlxSprite().makeGraphic(Std.int(width), 
            Std.int(height), 0x00000000), 0, 0, width, height, topL, topR, downL, downR, color);
    }
}