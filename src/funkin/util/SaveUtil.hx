package funkin.util;

@:access(flixel.util.FlxSave)
class SaveUtil
{
    public static function score():FlxSave
    {
        var scoreSave:FlxSave = new FlxSave();
		scoreSave.bind('high_score', CoolUtil.getSavePath());

        return scoreSave;
    }

    public static function gj():FlxSave
    {
        var gjSave:FlxSave = new FlxSave();
		gjSave.bind('gamejolt', CoolUtil.getSavePath());

        return gjSave;
    }

    public static function controls():FlxSave
    {
        var v3Controls:FlxSave = new FlxSave();
        v3Controls.bind('controls_v3', CoolUtil.getSavePath());

        return v3Controls;
    }

    public static function award():FlxSave
    {
        var awardSave:FlxSave = new FlxSave();
        awardSave.bind('achievements', CoolUtil.getSavePath());

        return awardSave;
    }

    public static function game():FlxSave
    {
        return FlxG.save;
    }

    inline public static function allSave():Void
    {
        if(score().data != null)
            try {
                score().flush();
            } catch(e)
                trace('lol $e');

        if(gj().data != null)
            try {
                gj().flush();
            } catch(e)
                trace('lol $e');

        if(controls().data != null)
            try {
                controls().flush();
            } catch(e)
                trace('yes $e');

        if(FlxG.save.data != null)
            FlxG.save.flush();
    }
}