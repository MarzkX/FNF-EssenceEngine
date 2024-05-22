package engine.states.editors;

import flixel.addons.display.FlxGridOverlay;

class ChartingTest extends MusicBeatState
{
    private var camGrid:FlxCamera;
    private var camHUD:FlxCamera;

    override function create() 
    {
        camGrid = new FlxCamera();
        camHUD = new FlxCamera();
        camHUD.bgColor.alpha = 0;
        FlxG.cameras.reset(camGrid);
        FlxG.cameras.add(camHUD, false);
        FlxG.cameras.setDefaultDrawTarget(camGrid, true);

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set();
		bg.color = 0xFF8134B4;
		add(bg);

        loadGrid();

        super.create();
    }

    var pressed:Bool = false;

    override function update(elapsed:Float)
    {
        if(!pressed)
        {
            if(FlxG.keys.justPressed.BACKSPACE)
            {
                pressed = true;
                FlxG.sound.play(Paths.sound('cancelMenu'));
                FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
                state(() -> new MasterEditorMenu());
            }
        }

        super.update(elapsed);
    }

    inline function loadGrid()
    {
        var grid1:FlxSprite = FlxGridOverlay.create(80, 80, 160, 160);
        insert(Std.int(grid1.x*grid1.width), grid1);
    }
}