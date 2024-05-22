package funkin.ui;

import funkin.util.WindowsUtil as WinStuff;
import flixel.addons.display.FlxSpriteAniRot;
import flixel.effects.FlxFlicker;
import flixel.util.FlxGradient;
import funkin.backend.Highscore;
import flixel.ui.FlxBar;

class InitState extends MusicBeatState
{
    var loaded:Float = 0;
    var bar:FlxBar;
    var spin:FlxSprite;
    var loaded_text:FlxText;

    override function create()
    {
        super.create();

        //Flixel stuff
        FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];
        FlxG.mouse.visible = false;
        FlxSprite.defaultAntialiasing = true;
        
        persistentUpdate = true;
        persistentDraw = true;

        //For Other
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.color = 0x181818;
        bg.antialiasing = true;
        add(bg);

        var gradient:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, 800, [0x00000000, 0xFF000000], 1, 90);
        gradient.antialiasing = true;
        gradient.scrollFactor.set();
        add(gradient);

        bar = new FlxBar(3, FlxG.height - 32.5, LEFT_TO_RIGHT, FlxG.width-6, 25, 
            this, 'loaded', 0, 1, true);
        bar.createFilledBar(0xC4FFFFFF, 0xC4000000, true, FlxColor.WHITE);
        add(bar);

        var lode:FlxSprite = new FlxSprite(2, FlxG.height - 35).loadGraphic(Paths.image('loadingbar'));
        lode.antialiasing = true;
        add(lode);

        loaded_text = new FlxText(52, FlxG.height - 65, 500, '', 16);
        loaded_text.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(loaded_text);

        spin = new FlxSprite(-12.5, FlxG.height - 90).loadGraphic(Paths.image('spinner'));
        spin.antialiasing = true;
        spin.scale.set(0.4, 0.4);
        FlxTween.tween(spin, {angle: 360}, 0.8, {type: LOOPING});
        add(spin);

        new FlxTimer().start(0.7, function(r:FlxTimer)
        {
            r = null;
            startConfig();
        });
    }

    function startConfig()
    {
        loaded_text.text = "Main Save's Loading...";
        ST.game().bind('main_saves', CoolUtil.getSavePath());
        FlxTween.num(0, 0.25, 0.4, {ease: FlxEase.quadOut}, 
            function(n:Float)
            {
                loaded = n;
            });

        //Save stuff
        if (ST.game().data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = ST.game().data.weekCompleted;
		}
        #if (cpp && windows)
        if (ST.game().data.darkMode != null)
            if (ST.game().data.darkMode)
                WinStuff.darkMode();
            else
                WinStuff.lightMode();
        #end
        if(ST.game().data != null && ST.game().data.fullscreen) FlxG.fullscreen = ST.game().data.fullscreen;
        loaded_text.text = "Score Save's Loading...";
        Highscore.load();
        FlxTween.num(0, 0.5, 0.4, {ease: FlxEase.quadOut}, 
            function(n:Float)
            {
                loaded = n;
            });
        #if GAMEJOLT_ALLOWED
        loaded_text.text = "GameJolt Save's Loading...";
        GJData.loadGJSettings();
        FlxTween.num(0, 0.75, 0.4, {ease: FlxEase.quadOut}, 
            function(n:Float)
            {
                loaded = n;
            });
        #end
        loaded_text.text = "Options Save's Loading...";
        ClientPrefs.loadPrefs();
        FlxTween.num(0, 0.925, 0.4, {ease: FlxEase.quadOut}, 
            function(n:Float)
            {
                loaded = n;
            });

        new FlxTimer().start(0.5, function(T:FlxTimer)
        {
            T = null;

            #if GAMEJOLT_ALLOWED
            loaded_text.text = "GameJolt/Screenshots Initialiasing...";
            GJClient.connect();
            funkin.util.plugins.ScreenshotPlugin.initialize();
            #else
            loaded_text.text = "Screenshots Initialiasing...";
            funkin.util.plugins.ScreenshotPlugin.initialize();
            #end

            FlxTween.num(0, 1, 0.4, {ease: FlxEase.quadOut,
                onComplete: function(R:FlxTween)
            {
                loaded_text.text = "Game Loaded!";
                FlxTween.tween(loaded_text, {alpha: 0}, 0.7);
                FlxTween.tween(bar, {alpha: 0}, 0.7);
                FlxTween.tween(spin, {alpha: 0}, 0.7);
                R = null;
            }}, 
                function(n:Float)
                {
                    loaded = n;
                });
        });

        new FlxTimer().start(1, function(T:FlxTimer)
        {
            T = null;
            state(new StartingState());
        });
    }
}

class StartingState extends MusicBeatState
{
    var lol:FlxSprite;

    override function create()
    {
        super.create();

        lol = new FlxSprite().loadGraphic(Paths.image('start'));
        lol.screenCenter();
        lol.antialiasing = ClientPrefs.data.antialiasing;
        add(lol);

        Cursor.show();
    }

    var selected:Bool = false;
    var lel:Int = 0;
    var lolTween:FlxTween;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(!selected)
        {
            if(FlxG.mouse.overlaps(lol))
            {
                if(lolTween != null)
                    lolTween.cancel();
                lolTween = null;
                Cursor.cursorMode = Pointer;

                lel++;
                if(lel == 1)
                    FlxG.sound.play(Paths.sound('scrollMenu'));

                if(FlxG.mouse.justPressed)
                {
                    FlxG.sound.play(Paths.sound('confirmMenu'));
                    FlxFlicker.flicker(lol, 1, 0.06, false, false, function(flick:FlxFlicker)
                    {
                        state(new TitleState()); 
                    });
                    selected = true;
                    Cursor.hide();
                }

                lolTween = FlxTween.tween(lol.scale, {x: 1.15, y: 1.15}, 0.15, {ease: FlxEase.quadOut, onComplete: function(t:FlxTween){t=null;}});
            }
            else
            {
                if(lolTween != null)
                    lolTween.cancel();

                lolTween = FlxTween.tween(lol.scale, {x: 1, y: 1}, 0.4, {ease: FlxEase.quadOut, 
                    onComplete: function(R:FlxTween)
                    {
                        lolTween = null;
                    }
                });

                Cursor.cursorMode = Default;
                lel = -1;
            }

            if(controls.ACCEPT)
            {
                FlxG.sound.play(Paths.sound('confirmMenu'));
                FlxFlicker.flicker(lol, 1, 0.06, false, false, function(flick:FlxFlicker)
                {
                    state(new TitleState()); 
                });
                selected = true;
                Cursor.hide();
            }
        }
    }
}