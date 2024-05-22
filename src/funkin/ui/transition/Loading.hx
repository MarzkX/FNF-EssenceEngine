package funkin.ui.transition;

import tjson.TJSON;
import flixel.ui.FlxBar;
import flixel.FlxState;
import openfl.Assets as OpenFlAssets;

class Loading extends MusicBeatState
{
    public var statewhat:FlxState;
    public var stateStr:String = '';
    public var jsonFile:Array<Dynamic> = null;
    var spin:FlxSprite;
    var spinTween:FlxTween;

    public function new(what:FlxState, string:String)
    {
        statewhat = what;
        stateStr = string;

        /*
        if(string.toLowerCase() == 'game')
        {
            var path:String = Paths.file('data/chartData/${Paths.formatToSongPath(PlayState.SONG.song)}/cache.json');
            if(OpenFlAssets.exists(path))
            {
                var data:String = OpenFlAssets.getText(path);
                try {
                    jsonFile = TJSON.parse(data);
                }
                catch(e)
                {
                    trace('$e');
                }
            }
        }*/// this will be soon...

        super();
    }

    var loaded_text:FlxText;
    var bar:FlxBar;
    var loaded:Float = 0;
    var wtf:Dynamic;

    override function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.color = 0x686868;
        bg.antialiasing = ClientPrefs.data.antialiasing;
        add(bg);

        bar = new FlxBar(3, FlxG.height - 32.5, LEFT_TO_RIGHT, FlxG.width-6, 25, 
            this, 'loaded', 0, 1, true);
        bar.createFilledBar(0xC4FFFFFF, 0xC4000000, true, FlxColor.WHITE);
        add(bar);

        var lode:FlxSprite = new FlxSprite(2, FlxG.height - 35).loadGraphic(Paths.image('loadingbar'));
        lode.antialiasing = true;
        add(lode);

        loaded_text = new FlxText(52, FlxG.height - 65, 500, 'Starting...', 16);
        loaded_text.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(loaded_text);

        spin = new FlxSprite(-12.5, FlxG.height - 90).loadGraphic(Paths.image('spinner'));
        spin.antialiasing = true;
        spin.scale.set(0.4, 0.4);
        add(spin);

        spinTween = FlxTween.tween(spin, {angle: 360}, 0.7, {type: LOOPING});

        //Caching start...
        new FlxTimer().start(0.7, function(T:FlxTimer)
        {
            T = null;
            startCache();
        });
    }

    function startCache()
    {
        switch(stateStr.toLowerCase())
        {
            /*
            case 'game':
                if(OpenFlAssets.exists(Paths.json('chartData/${Paths.formatToSongPath(PlayState.SONG.song)}/cache')))
                    {
                        try {
                            for(i in 0...jsonFile.length)
                            {
                                if(jsonFile[i].type == 'image') {
                                    loaded_text.text = 'Images Loading...';

                                    Paths.image(jsonFile[i].file, null, (jsonFile[i].allowGPU == 'auto' ? ClientPrefs.data.cacheOnGPU : jsonFile[i].allowGPU));
                                }
                                if(jsonFile[i].type == 'sound') {
                                    loaded_text.text = 'Sounds Loading...';

                                    Paths.sound(jsonFile[i].file);
                                }
                                if(jsonFile[i].type == 'music') {
                                    loaded_text.text = 'Music Loading...';

                                    Paths.music(jsonFile[i].file);
                                }
                                if(jsonFile[i].type == 'file') {
                                    loaded_text.text = 'Other Files Loading...';

                                    Paths.file(jsonFile[i].file, jsonFile[i].assetType);
                                }
                            }
                        }
                        catch(e)
                        {
                            trace('$e');
                        }
                    }

                loaded_text.text = '${stateStr} Loaded!';
                spinTween.cancel();

                spinTween = FlxTween.tween(spin, {alpha: 0}, 0.4);

                new FlxTimer().start(0.2, function(T:FlxTimer)
                {
                    FlxTween.num(0, 1, 0.4, {ease: FlxEase.quadOut, onComplete: function(t:FlxTween)
                        {
                            MusicBeatState.switchState(getNextState(statewhat, false));
                        }}, function(n:Float){loaded = n;});
                    T = null;
                });*/// soon..
            default:
                loaded_text.text = '${stateStr} Loaded!';

                new FlxTimer().start(0.2, function(T:FlxTimer)
                {
                    FlxTween.num(0, 1, 0.4, {ease: FlxEase.quadOut, onComplete: function(t:FlxTween)
                        {
                            state(() -> getNextState(statewhat, false));
                        }}, function(n:Float){loaded = n;});
                    T = null;
                });
        }
    }

    static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		var directory:String = 'mainFiles';
		Paths.setCurrentLevel(directory);
		trace('Setting asset folder to ' + directory);

		/*#if NO_PRELOAD_ALL
		var loaded:Bool = false;
		if (PlayState.SONG != null) {
			loaded = isSoundLoaded(getSongPath()) && (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath())) && isLibraryLoaded('week_assets');
		}
		
		if (!loaded)
			return new LoadingState(target, stopMusic, directory);
		#end*/
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		return target;
	}
}