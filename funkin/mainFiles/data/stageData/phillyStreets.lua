local function gp(prop)
    return getProperty(prop);
end

local function gpfc(from, prop)
    return getPropertyFromClass(from, prop);
end

local rainStartInten = 0;
local rainEndInten = 0;

function onCreate()
    runHaxeCode([[
        var bgAbot = new FlxSprite(700, 400).loadGraphic(Paths.image('characters/abot/stereoBG'));
        addBehindGF(bgAbot);

        /*var grpVisual = new FlxTypedGroup<FlxSprite>();
        addBehindGF(grpVisual);

        var volumes = [];

        var positionX = [0, 59, 56, 66, 54, 52, 51];
        var positionY = [0, -8, -3.5, -0.4, 0.5, 4.7, 7];

        for(i in 1...8)
        {
            volumes.push(0.0);
            var sum = function(num:Float, total:Float) return total += num;
            var posX = positionX.slice(0, lol).fold(sum, 0);
            var posY = positionY.slice(0, lol).fold(sum, 0);

            var visualizer:FlxSprite = new FlxSprite(posX, posY);
            visualizer.frames = Paths.getSparrowAtlas('stuff/aBotViz');
            grpVisual.add(visualizer);

            visualizer.animation.addByPrefix('VIZ', 'viz' + i, 0);
            visualizer.animation.play('VIZ');
        }*/

        var whitefuck:FlxSprite = new FlxSprite(550, 600).makeGraphic(125, 50);
        addBehindGF(whitefuck);

        var eyes:FlxAtlasSprite = new FlxAtlasSprite(17.5, -121.5, Paths.getPath('images/characters/abot/systemEyes'));
        eyes.anim.addBySymbolIndices('dad', 'StageInstance', [0,1,2], 24, false);
        eyes.anim.play('dad', false, false, 24);
        //addBehindGF(eyes);
    ]]);

    makeLuaSprite('cans','stages/phillyStreets/SpraycanPile',400,692.5);
    addLuaSprite('cans',true);

    if songName == 'Darnell' then
        rainStartInten = 0.0;
        rainEndInten = 0.1;
    elseif songName == 'Lit-Up' then
        rainStartInten = 0.1;
        rainEndInten = 0.2;
    elseif songName == '2Hot' then
        rainStartInten = 0.2;
        rainEndInten = 0.3;
    end

    makeLuaText('yess', '', 500, 0, 0);
    setObjectCamera('yess','camOther');
    addLuaText('yess');

    setBlendMode('trafficBlend','add');
    setBlendMode('lightsBlend','add')
end

function onCreatePost()
    initLuaShader("Rain", 100);
    makeLuaSprite("shaderSpr");
    setSpriteShader("shaderSpr", "Rain");

    setShaderFloatArray("shaderSpr","uScreenResolution",
        {
            gpfc('openfl.Lib', 'current.stage.stageWidth'),
            gpfc('openfl.Lib', 'current.stage.stageHeight')
        }
    );
    setShaderFloat('shaderSpr','uScale',screenHeight/200);
    setShaderFloat('shaderSpr', 'uIntensity', rainStartInten);

    runHaxeCode([[
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject('shaderSpr').shader)]);
        return;
    ]])
    setObjectOrder('smog',getObjectOrder('car4'));
end

local rainStarted = false;
local globalStart = true;

function onBeatHit()
    if rainStartInten < rainEndInten then
        if curBeat % 6 == 2 and getRandomBool(75) then
            rainStartInten = rainStartInten + 0.002;
            
            if globalStart then
                rainStarted = true;
            end
        end
    end
end

local time = 0;
function onUpdatePost(e)
    setTextString('yess', ''..getShaderFloat('shaderSpr', 'uIntensity')..'\n'..getProperty('smoothHealth'))

    setShaderFloat('shaderSpr', 'uIntensity', rainStartInten);
    
    time = time + e;

    setShaderFloatArray("shaderSpr", "uCameraBounds", 
        {
            gp('camGame.scroll.x') + gp('camGame.viewMarginX'),
            gp('camGame.scroll.y') + gp('camGame.viewMarginY'),
            gp('camGame.scroll.x') + (gp('camGame.width') - gp('camGame.viewMarginX')),
            gp('camGame.scroll.y') + (gp('camGame.height') - gp('camGame.viewMarginY'))
        }
    );
    setShaderFloat('shaderSpr','uTime',os.clock());

    if rainStarted then
        playSound('stages/phillyStreets/rainAmbience',0.075,'rainDrops');

        globalStart = false;
        rainStarted = false;
    end

    if keyboardJustPressed('I') then
        endSong();
    end
end

function onGameOver()
    stopSound('rainDrops');

    runHaxeCode([[
        game.camGame.setFilters([]);
        return;
    ]])
end

function onPause()
    pauseSound('rainDrops');
end

function onResume()
    resumeSound('rainDrops');
end

function onDestroy()
    stopSound('rainDrops');

    runHaxeCode([[
        game.camGame.setFilters([]);
        return;
    ]])
end