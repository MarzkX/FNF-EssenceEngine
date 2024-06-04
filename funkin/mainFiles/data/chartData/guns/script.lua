cutsceneStart = true;
path = 'stages/tankmanBattlefield/';

function onCreate()
    if cutsceneStart and not seenCutscene then
        runHaxeCode([[
            var man:FlxAtlasSprite = new FlxAtlasSprite(game.dad.x+418.5, game.dad.y+225, Paths.getPath('images/cutscenes/tankman'));
            man.anim.addBySymbol('talk1', 'TANK TALK 2', 24, false);
            man.anim.play('talk1');
            man.flipX = false;
            setVar('man',man);
            add(man);

            game.dadGroup.visible = false;
        ]])

        precacheSound(path..'tankSong2');

        setProperty('camHUD.visible',false);
    end
end

function onStartCountdown()
    if cutsceneStart and isStoryMode and not seenCutscene then
        startCutscene(11.5);
        triggerEvent('Camera Follow Pos', 525, 525);

        return Function_Stop;
    end
    return Function_Continue;
end

function startCutscene(timeEnd)
    playMusic('cutscene/DISTORTO');

    runTimer('first',0.01);
    doTweenZoom('camTween','camGame',0.835*1.2,4);
    runTimer('zoom',4.01);
    runTimer('zom',4.51);
    runTimer('endCutscene',timeEnd);
end

function onTimerCompleted(t)
    if t == 'first' then
        runHaxeCode([[
            getVar('man').anim.play('talk1');
        ]])

        playSound(path..'tankSong2')
    elseif t == 'zoom' then
        runHaxeCode([[
            game.gf.playAnim('sad', true);
			game.gf.animation.finishCallback = (name:String) ->
			{
				game.gf.playAnim('sad', true);
			};
        ]])
        doTweenZoom('camTween','camGame',0.835*1.2*1.2,0.5,'quadInOut');
    elseif t == 'zom' then
        doTweenZoom('camTween','camGame',0.835*1.2,1,'quadInOut');
    elseif t == 'endCutscene' then
        triggerEvent('Camera Follow Pos', '', '');
        doTweenZoom('camTween','camGame',getProperty('defaultCamZoom'),0.7,'quadInOut');

        runHaxeCode([[
            getVar('man').kill();
            game.dadGroup.visible = true;
        ]])
        setProperty('camHUD.visible',true);

        cutsceneStart = false;
        startCountdown();
    end
end