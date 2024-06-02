package funkin.ui.transition;

import flixel.util.typeLimit.NextState;
import flixel.addons.transition.FlxTransitionableState;
import openfl.display.Sprite;
import flixel.FlxState;

class StickerSubState extends MusicBeatSubstate
{
    /*
    public var grpStickers:FlxTypedGroup<StickerSprite>;
    public var dipshit:Sprite;

    var targetState:StickerSubState->FlxState;
    var soundSelections:Array<String> = [];
    var soundSelection:String = "";
    var sounds:Array<String> = [];

    public function new(?oldStickers:Array<StickerSprite>, ?targetState:StickerSubState->FlxState):Void
    {
        super();

        persistentUpdate = false;

        this.targetState = (targetState == null) ? ((sticker) -> new MainMenuState()) : targetState;

        var assetsInList = openfl.utils.Assets.list();
        var soundFilterFunc = function(a:String) return a.startsWith('funkin/sounds/stickersounds/');

        soundSelections = assetsInList.filter(soundFilterFunc);
        soundSelections = soundSelections.map(function(a:String) {
               return a.replace('funkin/sounds/stickersounds/', '').split('/')[0];
            });

        for(i in soundSelections)
        {
            while (soundSelections.contains(i)) {
                soundSelections.remove(i); }
            soundSelections.push(i);
        }

        trace(soundSelections);

        soundSelection = FlxG.random.getObject(soundSelections);

        var filterFunc = function(a:String) return a.startsWith('funkin/sounds/stickersounds/$soundSelection/');
        var assetsInList3 = openfl.utils.Assets.list();
        sounds = assetsInList3.filter(filterFunc);
        
        for(i in 0...sounds.length) {
            sounds[i] = sounds[i].replace('funkin/sounds/', '');
            sounds[i] = sounds[i].substring(0, sounds[i].lastIndexOf('.'));
        }

        grpStickers = new FlxTypedGroup<StickerSprite>();
        grpStickers.cameras = FlxG.cameras.list;
        add(grpStickers);

        if(oldStickers != null)
        {
            for (sticker in oldStickers)
                grpStickers.add(sticker);

            degenStickers();
        }
        else
            regenStickers();
    }

    public function degenStickers():Void
    {
        grpStickers.cameras = FlxG.cameras.list;

        if(grpStickers.members == null || grpStickers.members.length == 0)
        {
            persistentUpdate = true;
            switchingState = false;
            close();
            return;
        }

        for(ind => sticker in grpStickers.members)
            new FlxTimer().start(sticker.timing, _ -> {
                sticker.visible = false;
                var daSound:String = FlxG.random.getObject(sounds);
                FlxG.sound.play(PathSound.file(daSound));

                if(grpStickers == null || ind == grpStickers.members.length-1)
                {
                    persistentUpdate = true;
                    switchingState = false;
                    close();
                }
            });
    }

    public function regenStickers():Void
    {
        if(grpStickers.members.length > 0)
            grpStickers.clear();

        var stickerInfo:StickerInfo = new StickerInfo('stickers-set-1');
        var stickers:Map<String, Array<String>> = new Map<String, Array<String>>();
        for(stickerSets in stickerInfo.getPack("all"))
            stickers.set(stickerSets, stickerInfo.getStickers(stickerSets));

        var xPos:Float = -100;
        var yPos:Float = -100;
        while (xPos <= FlxG.width)
        {
            var sticker:String = FlxG.random.getObject(stickers.get(stickerInfo.getPack("all").pop()));
            var sticky:StickerSprite = new StickerSprite(0, 0, stickerInfo.name, sticker);
            sticky.visible = false;

            sticky.x = xPos;
            sticky.y = yPos;
            xPos += sticky.frameWidth * 0.5;

            if(xPos >= FlxG.width)
                if(yPos <= FlxG.height)
                {
                    xPos = -100;
                    yPos += FlxG.random.float(70, 120);
                }

            sticky.angle = FlxG.random.int(-60, 70);
            grpStickers.add(sticky);
        }

        FlxG.random.shuffle(grpStickers.members);

        for(ind => sticker in grpStickers.members)
        {
            sticker.timing = FlxMath.remapToRange(ind, 0, grpStickers.members.length, 0, 0.9);

            new FlxTimer().start(sticker.timing, _ -> {
                if(grpStickers == null) return;

                sticker.visible = true;
                var daSound:String = FlxG.random.getObject(sounds);
                FlxG.sound.play(PathSound.file(daSound));

                var frameTimer:Int = FlxG.random.int(0, 2);
                if(ind == grpStickers.members.length-1) frameTimer = 2;

                new FlxTimer().start((1/24)*frameTimer, _ -> {
                    if(sticker == null) return;

                    sticker.scale.x = sticker.scale.y = FlxG.random.float(0.97, 1.02);

                    if(ind == grpStickers.members.length-1)
                    {
                        switchingState = true;
                        FlxTransitionableState.skipNextTransIn = true;
                        FlxTransitionableState.skipNextTransOut = true;

                        EssenceFlxG.switchState(() -> {
                            Paths.clearUnusedMemory();
                            Paths.clearStoredMemory();

                            return targetState(this);
                        });
                    }
                });
            });
        }

    }

    var switchingState:Bool = false;

    override function close():Void
    {
        if(switchingState) return;
        super.close();    
    }

    override function destroy():Void
    {
        if(switchingState) return;
        super.destroy();
    }
    */

    var jsonInfo:StickerShit;
    var whatState:NextState;
    public var stickers:FlxTypedGroup<StickerSprite>;

    public function new(where:NextState)
    {
        super();

        this.whatState = where;

        //for(i in Std.int(0...99))
        //{
        var path:String = 'data/jsonData/transition/stickers-set-1/stickers.json';
        #if MODS_ALLOWED
        if(FileSystem.exists(Paths.getPath(path, TEXT, null, true)))
        #else
        if(openfl.utils.Assets.exists(Paths.getPath(path, TEXT)))
        #end
            jsonInfo = tjson.TJSON.parse(Paths.getTextFromFile(path));
        //}
    }

    var points:Array<Array<Float>> = [
        //X
        [240, 100, 682, 1280, 500, 800, 1000, 1100, 0,   1080, 1150, 625, 0,   400, 200, 100, 400, 300, 845, 1275, 800, 700, 0],
        //Y
        [60,  500, 0,   425,  300, 621, 200,  282,  700, 697,  586, 25,  100, 0,   125, 500, 612, 315, 720, 673,  0,   134, 682]
    ];
    var point1Num:Int = 0;
    var nummm:Int = 0;
    var point2Num:Int = 0;
    var pointBool:Bool = true;
    var stickerSounds:FlxSound;

    override function create()
    {
        super.create();

        cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];

        stickerSounds = new FlxSound();
        FlxG.sound.list.add(stickerSounds);

        stickers = new FlxTypedGroup<StickerSprite>();
        add(stickers);

        spawnStickers();

        new FlxTimer().start(1, (t:FlxTimer) -> {pointBool=false;t=null;});

        new FlxTimer().start(2, function(t:FlxTimer)
        {
            FlxTransitionableState.skipNextTransOut = false;
            FlxG.switchState(whatState);
            t = null;
        });
    }

    function spawnStickers()
    {
        if(pointBool)
        {
            nummm++;

            var sticker:StickerSprite = new StickerSprite(points[0][point1Num], points[1][point2Num], 1, jsonInfo.stickers[FlxG.random.int(0,jsonInfo.stickers.length-1)]);
            sticker.ID = nummm;
            sticker.scale.set(0, 0);
            sticker.angle = FlxG.random.float(-60, 50);
            FlxTween.tween(sticker.scale, {x: 1, y: 1}, 0.093458793655, {ease: FlxEase.cubeOut});
            stickers.add(sticker);

            new FlxTimer().start(0.01283687324875, (t:FlxTimer) -> {t=null;spawnStickers();});

            FlxG.sound.play(Paths.soundRandom('stickersounds/keys/keyClick', 1, 9));
    
            if(point1Num > points[0].length)
                point1Num = -1;

            point1Num++;

            if(point2Num > points[1].length)
                point2Num = -1;

            point2Num++;
        }
    }
}

class StickerSprite extends FlxSprite
{
    public var timing:Float = 0;

    public function new(x:Float, y:Float, stickerSet:Int, stickerName:String):Void
    {
        super(x, y);
        loadGraphic(PathImage.ui('transitionSwag/stickers-set-$stickerSet/$stickerName'));
        antialiasing = ClientPrefs.data.antialiasing;
        updateHitbox();
        scrollFactor.set();
    }
}

/*class StickerInfo
{
    public var name:String;
    public var artist:String;
    public var stickers:Map<String, Array<String>>;
    public var stickerPacks:Map<String, Array<String>>;

    public function new(stickerSet:String):Void
    {
        var jsonInfo:StickerShit = tjson.TJSON.parse(Paths.getTextFromFile('data/jsonData/transition/' + stickerSet + '/stickers.json'));
        this.name = jsonInfo.name;
        this.artist = jsonInfo.artist;

        stickerPacks = new Map<String, Array<String>>();

        for(field in Reflect.fields(jsonInfo.stickerPacks))
        {
            var stickerFunny = jsonInfo.stickers;
            stickers.set(field, cast Reflect.field(stickerFunny, field));
        }
    }

    public function getStickers(theSticker:String):Array<String>
        return this.stickers[theSticker];

    public function getPack(thePack:String):Array<String>
        return this.stickerPacks[thePack];
}*/

typedef StickerShit = {
    name:String,
    artist:String,
    stickers:Array<String>
}