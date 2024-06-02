package funkin.ui;

import flixel.addons.ui.FlxUIGroup;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxSpriteUtil;
import engine.display.RoundRect;
import flixel.util.FlxGradient;
import engine.options.OptionsState;

class GameJoltState extends MusicBeatState
{
    public static var isOptions:Bool = false;

    public static var logged:Bool = false;
    var isGame:Bool = false;

    public function new(?isPlayState:Bool = false)
    {
        isGame = isPlayState;

        super();
    }

    var logo:FlxSprite;
    var blank:FlxSprite;
    var user_box:FlxUIInputText;
    var token_box:FlxUIInputText;

    var log_butt:FlxSprite;
    var get_butt:FlxSprite;
    var create_butt:FlxSprite;
    
    override function create()
    {
        super.create();

        Cursor.show();

        var bg:FlxSprite = new FlxSprite().loadGraphic(PathImage.def_bg());
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.setGraphicSize(FlxG.width, FlxG.height);
        bg.updateHitbox();
        bg.screenCenter();
        bg.scrollFactor.set();
        bg.color = 0xFF9438E0;
        add(bg);

        var gradient:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, 800, [0x00000000, 0xF100FF00], 1, 90);
        gradient.antialiasing = ClientPrefs.data.antialiasing;
        gradient.alpha = 0.925;
        gradient.scrollFactor.set();
        add(gradient);

        var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x18FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

        logo = new FlxSprite().loadGraphic(Paths.image('logo', 'gamejolt', ClientPrefs.data.cacheOnGPU));
        logo.setGraphicSize(FlxG.width, FlxG.height);
        logo.antialiasing = false;
        logo.updateHitbox();
        add(logo);

        if(!GJClient.userLogin)
        {
            blank = RoundRect.rect(new FlxSprite().makeGraphic(Std.int((FlxG.width/5)*3), 
                Std.int((FlxG.height/2)*1.2), 0x00000000), (FlxG.width/5)*3, (FlxG.height/2)*1.2, 10, 10, 0xFF000000);
            blank.screenCenter();
            blank.alpha = 0.6;
            blank.scrollFactor.set();
            add(blank);
            add(new FlxText(385, blank.y+5, 505, 'Log In', 28).setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, CENTER, OUTLINE));
        
            var boxBG1:FlxSprite = RoundRect.rect(new FlxSprite().makeGraphic(Std.int(blank.width - 20), 50, 0x00000000), blank.width - 20, 50, 10, 10, 0xFF000000);
            boxBG1.alpha = 0.6;
            add(boxBG1);
        
            user_box = new FlxUIInputText(blank.x + 15, blank.y + 85, Std.int(blank.width - 25), null, 32, 0xFFFFFF, 0x00000000);
            add(user_box);
    
            add(new FlxText(blank.x + 10, user_box.y - 30, 500, 'User:', 20).setFormat(Paths.font('vcr.ttf'), 22, FlxColor.WHITE, LEFT, OUTLINE, 0x000000));
        
            boxBG1.x = user_box.x - 5;
            boxBG1.y = user_box.y - 5;
        
            var boxBG2:FlxSprite = RoundRect.rect(new FlxSprite().makeGraphic(Std.int(blank.width - 20), 50, 0x00000000), blank.width - 20, 50, 10, 10, 0xFF000000);
            boxBG2.alpha = 0.6;
            add(boxBG2);
        
            token_box = new FlxUIInputText(blank.x + 15, user_box.y + 85, Std.int(blank.width - 25), null, 32, 0xFFFFFF, 0x00000000);
            add(token_box);
        
            add(new FlxText(blank.x + 10, token_box.y - 30, 500, 'Token:', 20).setFormat(Paths.font('vcr.ttf'), 22, FlxColor.WHITE, LEFT, OUTLINE, 0x000000));
        
            boxBG2.x = token_box.x - 5;
            boxBG2.y = token_box.y - 5;
        
            log_butt = RoundRect.rect(new FlxSprite().makeGraphic(Std.int((blank.width/3)-50), 50, FlxColor.TRANSPARENT), (blank.width/3)-50, 50, 12.5, 12.5, FlxColor.LIME);
            log_butt.screenCenter();
            log_butt.alpha = 0.6;
            log_butt.y += 75;
            add(log_butt);
        
            get_butt = RoundRect.rect(new FlxSprite().makeGraphic(Std.int((blank.width/3)-50), 50, FlxColor.TRANSPARENT), (blank.width/3)-50, 50, 12.5, 12.5, FlxColor.YELLOW);
            get_butt.screenCenter();
            get_butt.x -= (blank.width/3)-35;
            get_butt.alpha = 0.6;
            get_butt.y += 150;
            add(get_butt);
        
            create_butt = RoundRect.rect(new FlxSprite().makeGraphic(Std.int((blank.width/3)-50), 50, FlxColor.TRANSPARENT), (blank.width/3)-50, 50, 12.5, 12.5, 0xFF537A6D);
            create_butt.screenCenter();
            create_butt.x += (blank.width/3)-35;
            create_butt.alpha = 0.6;
            create_butt.color = 0xFF537A6D;
            create_butt.y += 150;
            add(create_butt);
        }
        else
        {
            blank = RoundRect.rect(new FlxSprite().makeGraphic(Std.int((FlxG.width/5)*2), 
                Std.int((FlxG.height/2)*1.2), 0x00000000), (FlxG.width/5)*2, (FlxG.height/2)*1.2, 10, 10, 0xFF000000);
            blank.screenCenter();
            blank.alpha = 0.6;
            blank.scrollFactor.set();
            add(blank);
            add(new FlxText(385, blank.y+5, 505, 'Signed!', 28).setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, CENTER, OUTLINE));
        }
    }

    var selected:Bool = false;
    var num1_select:Int = 0;
    var num2_select:Int = 0;
    var num3_select:Int = 0;

    override function update(elapsed:Float)
    {    
        super.update(elapsed);

        if(!selected)
        {
            if(!GJClient.userLogin)
            {
                if(FlxG.keys.justPressed.ESCAPE)
                {
                    Cursor.hide();
                    selected = true;
                    if(isOptions) {    
                        state(() -> new OptionsState());
                    } else
                        state(() -> new MainMenuState());
                    FlxG.sound.play(PathSound.file('cancelMenu'));
                }

                if(FlxG.mouse.overlaps(logo) && FlxG.mouse.justPressed)
                    CoolUtil.browserLoad(Constants.URL_GAME);

                if(FlxG.mouse.overlaps(log_butt) || FlxG.mouse.overlaps(get_butt) || FlxG.mouse.overlaps(create_butt))
                    Cursor.cursorMode = Pointer;
                else
                    Cursor.cursorMode = Default;

                if(FlxG.mouse.overlaps(log_butt))
                {
                    num1_select++;
                    if(num1_select == 1)
                        FlxG.sound.play(PathSound.file('scrollMenu'), 0.7);
                    log_butt.alpha = 1;

                    if(FlxG.mouse.justPressed)
                    {
                        if(user_box.text != null && user_box.text != '' && token_box.text != null && token_box.text != '') {
                            GJClient.authDaUser(user_box.text, token_box.text, true);
                            FlxG.sound.play(PathSound.file('confirmMenu'));
                        } else {
                            trace('USER && TOKEN WITHOUT TEXT\'S!');
                            FlxG.sound.play(PathSound.file('cancelMenu'));
                        }
                    }
                }
                else
                {
                    num1_select = -1;
                    log_butt.alpha = 0.6;
                }

                if(FlxG.mouse.overlaps(get_butt))
                {
                    num2_select++;
                    if(num2_select == 1)
                        FlxG.sound.play(PathSound.file('scrollMenu'), 0.7);
                    get_butt.alpha = 1;

                    if(FlxG.mouse.justPressed)
                    {
                        CoolUtil.browserLoad('https://youtu.be/Zod80sfysMc');
                        FlxG.sound.play(PathSound.file('cancelMenu'),0.7);
                    }
                }
                else
                {
                    num2_select = -1;
                    get_butt.alpha = 0.6;
                }

                if(FlxG.mouse.overlaps(create_butt))
                {
                    num3_select++;
                    if(num3_select == 1)
                        FlxG.sound.play(PathSound.file('scrollMenu'), 0.7);
                    create_butt.alpha = 1;

                    if(FlxG.mouse.justPressed)
                    {
                        CoolUtil.browserLoad('https://gamejolt.com/discover');
                        FlxG.sound.play(PathSound.file('cancelMenu'),0.7);
                    }
                }
                else
                {
                    num3_select = -1;
                    create_butt.alpha = 0.6;
                }
            }
            else
            {
                if(controls.BACK)
                {
                    Cursor.hide();
                    selected = true;
                    if(isOptions) {    
                        state(() -> new OptionsState());
                    } else
                        state(() -> new MainMenuState());
                    FlxG.sound.play(PathSound.file('cancelMenu'));
                }
            }
        }
    }
}