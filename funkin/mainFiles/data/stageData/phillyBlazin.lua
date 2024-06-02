local function gp(prop)
    return getProperty(prop);
end

local function gpfc(from, prop)
    return getPropertyFromClass(from, prop);
end

function onCreate()
    runHaxeCode([[
        var bgAbot = new FlxSprite(500, 500).loadGraphic(Paths.image('characters/abot/stereoBG'));
        addBehindGF(bgAbot);
    ]])
    --setProperty('light.visible',false);
    --setProperty('light2.visible',false);
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
    setShaderFloat("shaderSpr", "uIntensity",0.3);
    setProperty('gfGroup.color', getColorFromHex('757575'))

    runHaxeCode([[
        game.camGame.setFilters([new ShaderFilter(game.getLuaObject('shaderSpr').shader)]);
        return;
    ]])

    setObjectOrder('gfGroup', 7)
end

local time = 0;
function onUpdatePost(e)
    time = time + e;

    setShaderFloatArray("shaderSpr", "uCameraBounds", 
        {
            gp('camGame.scroll.x') + gp('camGame.viewMarginX'),
            gp('camGame.scroll.y') + gp('camGame.viewMarginY'),
            gp('camGame.scroll.x') + (gp('camGame.width') - gp('camGame.viewMarginX')),
            gp('camGame.scroll.y') + (gp('camGame.height') - gp('camGame.viewMarginY'))
        }
    );
    setShaderFloat('shaderSpr','uTime',(time)/4);
end
local lightningStrikeBeat = 0;
local lightningOffset = 0;
function onBeatHit()
    if getRandomBool(5) and curBeat > lightningStrikeBeat + lightningOffset then
        thunderEffect();
    end
end

function onTimerCompleted(t)
    if t == 'realistic' then
        playSound('stages/phillyStreets/Lightning'..getRandomInt(1,3), 0.6);
    end
end

function thunderEffect()
    lightningStrikeBeat = curBeat;
	lightningOffset = getRandomInt(8, 24);

    if getRandomBool(50) then
        setProperty('light.visible',true);
        playAnim('light','idle')
    else
        setProperty('light2.visible',true);
        playAnim('light2','idle');
    end

    runTimer('realistic',0.2);

    if getProperty('camZooming') then
        triggerEvent('Add Camera Zoom', 0.015, 0.03);
    end

    cameraShake('camGame', 0.0015, 0.2);
end

function onGameOver()
    runHaxeCode([[
        game.camGame.setFilters([]);
        return;
    ]])
end

function onDestroy()
    runHaxeCode([[
        game.camGame.setFilters([]);
        return;
    ]])
end