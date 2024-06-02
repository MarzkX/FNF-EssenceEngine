songs = {
    "2Hot"
};

function onCreate()
    addHaxeLibrary('GameOverSubstate', 'funkin.ui.ingame');

    for i=0,#songs do
        addCharacterToList('pico-shoot', 'bf');

        precacheSound('stages/phillyStreets/Gun_Prep');
        precacheSound('stages/phillyStreets/Pico_Bonk');
        
        for j=0,5 do
            precacheSound('stages/phillyStreets/shot'..j);
        end
    end

    makeAnimatedLuaSprite('canFly','stages/phillyStreets/wked1_cutscene_1_can',425,300);
    addAnimationByPrefix('canFly','kick','can kick quick',11,false);
    addAnimationByPrefix('canFly','fly','can kicked up',24,false);
    addAnimationByPrefix('canFly','lox','can kicked up001',24,false);
    setObjectOrder('canFly',getObjectOrder('cans'));
    setProperty('canFly.visible',false);
    addLuaSprite('canFly',true);

    makeAnimatedLuaSprite('explosion','stages/phillyStreets/SpraypaintExplosion',495,-210);
    addAnimationByPrefix('explosion','boom','Explosion 1 movie',24,false);
    setProperty('explosion.visible',false);
    addLuaSprite('explosion',true);

    makeAnimatedLuaSprite('expw','stages/phillyStreets/spraypaintExplosionEZ',750,20);
    addAnimationByPrefix('expw','boom','explosion round 1 short',24,false);
    setProperty('expw.visible',false);
    addLuaSprite('expw',true);

    makeLuaSprite('exp','stages/phillyStreets/explosion',800,150);
    scaleObject('exp', 0.9, 0.9)
    setProperty('exp.angle',15)
    setProperty('exp.alpha',.001);
    addLuaSprite('exp',true);

    runHaxeCode([[
        var theMissed:Bool = false;
        setVar('theMissed', theMissed);
    ]])
end

local pressedLol = false;
local willMiss = true;
local presss = -1;

function goodNoteHit(id, dir, nt, isSus)
    if not isSus then
        if nt == 'Pico Shoot' then
            triggerEvent('Change Character', 'bf', 'pico-shoot');

            if presss > 1 then
                presss = 0;
            end

            presss = presss + 1;

            if dir == 1 then
                setProperty('theMissed',false);

                triggerEvent('Play Animation', 'start', 'bf');
                playSound('stages/phillyStreets/Gun_Prep');

                setProperty('wowEffect.alpha',0.6);
                doTweenAlpha('wowTween','wowEffect',.001,0.6);

                scaleObject('wowEffect', 1, 1);
                startTween('wowTween1', 'wowEffect.scale', {x = 1.15, y = 1.15}, 2, {ease = 'quadOut'})
            end

            if dir == 0 and getProperty('theMissed') then
                pressedLol = false;

                setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'isPico', true);
                setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'characterName', 'pico-explosion-dead');
                setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'deathSoundName', 'gameover/fnf_loss_sfx-pico-explode');
                setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'endSoundName', 'gameover/gameOverEnd-pico');
                setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'loopSoundName', 'gameover/gameOverStart-pico-explode');

                triggerEvent('Camera Follow Pos', '', '');
                setProperty('defaultCamZoom',0.75);

                triggerEvent('Play Animation', 'lose', 'bf');
                playSound('stages/phillyStreets/Pico_Bonk');
                flickerEffect();

                runHaxeCode([[
                    game.iconP2.animation.curAnim.curFrame = 0;
                ]])

                setProperty('theMissed',false);
                runTimer('healthMissLol',0.1);
            elseif dir == 0 and not getProperty('theMissed') then
                pressedLol = true;

                triggerEvent('Camera Follow Pos', '', '');
                setProperty('defaultCamZoom',0.75);
    
                triggerEvent('Play Animation', 'shoot', 'bf');
                playSound('stages/phillyStreets/shot'..getRandomInt(1,4));
    
                setProperty('blackfuck.alpha',1);
                doTweenAlpha('blackTween','blackfuck',.001,1);
    
                playAnim('explosion','boom');
                setProperty('exp.alpha',1);
                stopSound('fuse');
                setProperty('explosion.visible',true);
                setProperty('canFly.visible',false);
                runTimer('lol',0.05);
            end
        end
    end
end

function onSongStart()
    --startVideo('2hotCutscene'); --Play video file from "videos/" folder
end

local expDead = false;

function onStepHit()
    if isStoryMode then
        if curStep == 1440 then
            triggerEvent('Camera Follow Pos', 900, 470);
            setProperty('defaultCamZoom',0.725);
        end
    end
end

function noteMiss(id, dir, nt, isSus)
    if not isSus then
        if nt == 'Pico Shoot' then
            if dir == 1 then
                setProperty('theMissed',true);
            end

            if dir == 0 then
                triggerEvent('Camera Follow Pos', '', '');

                setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'isPico', true);
                setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'characterName', 'pico-explosion-dead');
                setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'deathSoundName', 'gameover/fnf_loss_sfx-pico-explode');
                setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'endSoundName', 'gameover/gameOverEnd-pico');
                setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'loopSoundName', 'gameover/gameOverStart-pico-explode');

                pressedLol = false;

                triggerEvent('Change Character', 'bf', 'pico-shoot')

                triggerEvent('Play Animation', 'lose', 'bf');
                playSound('stages/phillyStreets/Pico_Bonk');
                flickerEffect();

                runHaxeCode([[
                    game.iconP2.animation.curAnim.curFrame = 0;
                ]])

                setProperty('defaultCamZoom',0.75);

                runTimer('healthMissLol',0.1);
            end
        end
    end
end

function onUpdate(e)
    if (getProperty('boyfriend.animation.curAnim.name') == 'shoot' or getProperty('boyfriend.animation.curAnim.name') == 'lose') and getProperty('boyfriend.animation.curAnim.finished') then
        triggerEvent('Change Character', 'bf', 'pico-player');
    end

    if getProperty('dad.animation.curAnim.name') == 'kickUp' and getProperty('dad.animation.curAnim.curFrame') == 0 then
        setProperty('canFly.visible',true);
        setProperty('canFly.x',425);
        setProperty('canFly.y',300);
        playAnim('canFly','fly');
        setProperty('defaultCamZoom',0.725);
    elseif getProperty('dad.animation.curAnim.name') == 'attack' and getProperty('dad.animation.curAnim.curFrame') == 0 then
        playAnim('canFly','kick');
    end

    if getProperty('canFly.animation.curAnim.name') == 'kick' and getProperty('canFly.animation.curAnim.finished') then
        setProperty('canFly.x',1400);
        setProperty('canFly.y',315);
        setProperty('canFly.angle',15)
        playAnim('canFly','lox',false,true);

        runTimer('canT',0.125);
        runTimer('expl',0.175);
    end

    if getProperty('explosion.animation.curAnim.finished') then
        setProperty('explosion.visible',false);
    end
end

function onEvent(n, v1, v2)
    if n == 'Play Animation' then
        if v1 == 'start' and v2 == 'dad' then
            triggerEvent('Camera Follow Pos', 900, 470);
        end
    end
end

function flickerEffect()
    for i=0,12 do
        cancelTimer('f'..i);
    end

    setProperty('boyfriendGroup.alpha',1);
    runTimer('f1', 0.2);
end

function onTimerCompleted(t)
    if t == 'lol' then
        setProperty('exp.alpha',.001);
    end

    if t == 'canT' then
        setProperty('canFly.x',1350);
        setProperty('canFly.y',300);
        setProperty('canFly.angle',5)
    end

    if t == 'expl' and not pressedLol then
        setProperty('canFly.visible',false);
        playAnim('expw','boom');
        setProperty('expw.visible',true);
    end

    if t == 'f1' then
        setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'isPico', false);
        setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'characterName', 'pico-dead');
        setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'deathSoundName', 'gameover/fnf_loss_sfx-pico');
        setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'loopSoundName', 'gameover/gameOver-pico');
        setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'endSoundName', 'gameover/gameOverEnd-pico');

        setProperty('theMissed',false);

        setProperty('boyfriendGroup.alpha',.001);
        runTimer('f2', 0.15);
    end

    if t == 'f2' then
        setProperty('boyfriendGroup.alpha',1);
        runTimer('f3', 0.1);
    end

    if t == 'f3' then
        setProperty('boyfriendGroup.alpha',.001);
        runTimer('f4', 0.1);
    end

    if t == 'f4' then
        setProperty('boyfriendGroup.alpha',1);
        runTimer('f5', 0.1);
    end

    if t == 'f5' then
        setProperty('boyfriendGroup.alpha',.001);
        runTimer('f6', 0.1);
    end

    if t == 'f6' then
        setProperty('boyfriendGroup.alpha',1);
        runTimer('f7', 0.1);
    end

    if t == 'f7' then
        setProperty('boyfriendGroup.alpha',.001);
        runTimer('f8', 0.1);
    end

    if t == 'f8' then
        setProperty('boyfriendGroup.alpha',1);
        runTimer('f9', 0.1);
    end

    if t == 'f9' then
        setProperty('boyfriendGroup.alpha',.001);
        runTimer('f10', 0.1);
    end

    if t == 'f10' then
        setProperty('boyfriendGroup.alpha',1);
        runTimer('f11', 0.1);
    end

    if t == 'f11' then
        setProperty('boyfriendGroup.alpha',.001);
        runTimer('f12', 0.1);
    end

    if t == 'f12' then
        setProperty('boyfriendGroup.alpha',1);
    end

    if t == 'healthMissLol' then
        setProperty('health',getProperty('health')-1);
    end
end