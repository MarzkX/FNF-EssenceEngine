local lightningStrikeBeat = 0;
local lightningOffset = 0;
local isStarting = false;

function onCreate()
    if songName == 'Monster' and isStoryMode then
        isStarting = true;
    end
end


function onCreatePost()
    if songName == 'Monster' and isStoryMode then
        triggerEvent('Camera Follow Pos', 395, 400);
        triggerEvent('Add Camera Zoom', 0.2, 0);

        setProperty('whitefuck.alpha',1);
    end
end

function onBeatHit()
    if getRandomBool(10) and curBeat > lightningStrikeBeat + lightningOffset then
        thunderEffect();
    end
end

function thunderEffect()
    playAnim('halloweenBG', 'flash');
    playSound('stages/spookyMansion/thunder_'..getRandomInt(1,2));

    lightningStrikeBeat = curBeat;
	lightningOffset = getRandomInt(8, 24);

    runHaxeCode([[
        if(game.boyfriend.animOffsets.exists('scared'))
            game.boyfriend.playAnim('scared', true);

        if(game.dad.animOffsets.exists('scared'))
            game.dad.playAnim('scared', true);

        if(game.gf.animOffsets.exists('scared'))
            game.gf.playAnim('scared', true);
    ]]);

    if getProperty('camZooming') then
        triggerEvent('Add Camera Zoom', 0.015, 0.03);
    end
end

function onUpdate(e)
    if getProperty('halloweenBG.animation.curAnim.name') == 'flash' and
            getProperty('halloweenBG.animation.curAnim.finished') then
        playAnim('halloween', 'idle');
    end
end

function onStartCountdown()
    if isStarting and isStoryMode then
        thunderEffect();

        if flashingLights then
            runTimer('fadeOut',0.2);
        end
        runTimer('startSong', 2);

        return Function_Stop;
    end
    return Function_Continue;
end

function onTimerCompleted(t)
    if t == 'startSong' then
        isStarting = false;
        triggerEvent('Camera Follow Pos', '', '');

        startCountdown();
    end

    if t == 'fadeOut' then
        doTweenAlpha('whitefuckTween', 'whitefuck', 0, 0.7);
    end
end