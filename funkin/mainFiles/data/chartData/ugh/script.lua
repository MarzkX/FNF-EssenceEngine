cutsceneStart = true;
path = 'stages/tankmanBattlefield/';

function onCreate()
    if cutsceneStart and not seenCutscene then
        runHaxeCode([[
            var man:FlxAtlasSprite = new FlxAtlasSprite(game.dad.x+418.5, game.dad.y+225, Paths.getPath('images/cutscenes/tankman'));
            man.anim.addBySymbol('talk1', 'TANK TALK 1 P1', 24, false);
            man.anim.addBySymbol('talk2', 'TANK TALK 1 P2', 24, false);
            man.anim.play('talk1');
            man.flipX = false;
            setVar('man',man);
            add(man);

            game.dadGroup.visible = false;
        ]])

        precacheSound(path..'wellWellWell');
        precacheSound(path..'bfBeep');
        precacheSound(path..'killYou');

        setProperty('camHUD.visible',false);
    end
end

function onStartCountdown()
    if cutsceneStart and isStoryMode and not seenCutscene then
        startCutscene(12);
        triggerEvent('Camera Follow Pos', 525, 525);

        return Function_Stop;
    end
    return Function_Continue;
end

function startCutscene(timeEnd)
    playMusic('cutscene/DISTORTO');

    runTimer('first',0.1);
    runTimer('zoom',3);
    runTimer('bip',4.5);
    runTimer('killU',6);
    runTimer('endCutscene',timeEnd);
end

function onTimerCompleted(t)
    if t == 'first' then
        runHaxeCode([[
            getVar('man').anim.play('talk1');
        ]])

        playSound(path..'wellWellWell')
    elseif t == 'zoom' then
        triggerEvent('Camera Follow Pos', 1000, 535);
        doTweenZoom('camTween','camGame',1.05,0.75,'quadOut');
    elseif t == 'bip' then
        characterPlayAnim('bf', 'singUP');
        setProperty('boyfriend.specialAnim',true);

        playSound(path..'bfBeep');
    elseif t == 'killU' then
        triggerEvent('Camera Follow Pos', 525, 525);
        doTweenZoom('camTween','camGame',getProperty('defaultCamZoom'),0.75,'quadIn');

        runHaxeCode([[
            getVar('man').anim.play('talk2');
        ]])

        playSound(path..'killYou');
    elseif t == 'endCutscene' then
        triggerEvent('Camera Follow Pos', '', '');

        runHaxeCode([[
            getVar('man').kill();
            game.dadGroup.visible = true;
        ]])
        setProperty('camHUD.visible',true);

        cutsceneStart = false;
        startCountdown();
    end
end