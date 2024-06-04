cutsceneStart = true;
path = 'stages/tankmanBattlefield/';

function onCreate()
    if cutsceneStart and isStoryMode and not seenCutscene then
        makeLuaSprite('blackpink') --lol
        makeGraphic('blackpink',4000,3000,'BF1052');
        setProperty('blackpink.x',-700);
        setProperty('blackpink.y',-700);
        setProperty('blackpink.alpha',0);
        addLuaSprite('blackpink',false);

        runHaxeCode([[
            var man:FlxAtlasSprite = new FlxAtlasSprite(game.dad.x+418.5, game.dad.y+225, Paths.getPath('images/cutscenes/tankman'));
            man.anim.addBySymbol('talk1', 'TANK TALK 3 P1 UNCUT', 24, false);
            man.anim.addBySymbol('talk2', 'TANK TALK 3 P2 UNCUT', 24, false);
            man.anim.play('talk1');
            man.flipX = false;
            setVar('man',man);
            add(man);

            var pico:FlxAtlasSprite = new FlxAtlasSprite(game.gf.x + 150, game.gf.y + 450, Paths.getPath('images/cutscenes/picoAppears'));
            pico.anim.addBySymbol('dance', 'GF Dancing at Gunpoint', 24, true);
            pico.anim.addBySymbol('dieBitch', 'GF Time to Die sequence', 24, false);
            pico.anim.addBySymbol('picoAppears', 'Pico Saves them sequence', 24, false);
            pico.anim.addBySymbol('picoEnd', 'Pico Dual Wield on Speaker idle', 24, false);
            pico.anim.play('dance', true);
            setVar('pico',pico);
            addBehindGF(pico);

            game.gfGroup.visible = false;
            game.boyfriendGroup.visible = false;
            game.dadGroup.visible = false;
        ]])

        precacheSound(path..'stressCutscene');

        makeAnimatedLuaSprite('fakebf','characters/BOYFRIEND',getProperty('boyfriend.x')+2.5,getProperty('boyfriend.y')+22.5);
        addAnimationByPrefix('fakebf','idle','BF idle dance',24,false);
        addLuaSprite('fakebf',true);

        setProperty('camHUD.visible',false);
    end

    if not isStoryMode or seenCutscene then
        for i=0,5 do
            setProperty('tank'..i..'.y', getProperty('tank'..i..'.y')+100);
        end
    end

    addHaxeLibrary('FlxFlicker','flixel.effects');
    precacheImage('stages/tankmanBattlefield/tankmanKilled1');
end

local gfCum = {725, 295}

function onStartCountdown()
    if cutsceneStart and isStoryMode and not seenCutscene then
        startCutscene(35.5);
        triggerEvent('Camera Follow Pos', 525, 525);

        return Function_Stop;
    end
    return Function_Continue;
end

function startCutscene(timeEnd)
    runTimer('first',0.01);
    runTimer('cumfollow',15.21);
    runTimer('zoomback',17.51);
    runTimer('tank',19.51);
    runTimer('cumlol',20.1);
    runTimer('osk',31.21);
    runTimer('zum',32.21);
    runTimer('endCutscene',timeEnd);
end

numerally = 0;

function tankmeh()    
    numerally = numerally + 1;

    makeAnimatedLuaSprite('john'..numerally,'stages/tankmanBattlefield/tankmanKilled1',-700,175);
    addAnimationByPrefix('john'..numerally,'run','tankman running',24,true);
    addAnimationByPrefix('john'..numerally,'shot1','John Shot 1',24,false);
    addAnimationByPrefix('john'..numerally,'shot2','John Shot 2',24,false);
    setProperty('john'..numerally..'.flipX',true);
    playAnim('john'..numerally,'run');
    addOffset('john'..numerally, 'shot1', 500,175);
    addOffset('john'..numerally, 'shot2', 500,175);
    addLuaSprite('john'..numerally,false);

    doTweenX('tet1'..numerally,'john'..numerally,100,1/getProperty('playbackRate'));
    doTweenY('tet2'..numerally,'john'..numerally,125,1/getProperty('playbackRate'));

    runTimer('ey1'..numerally,0.895/getProperty('playbackRate'));
end

local numerallya = 0;

function tankmen()
    numerallya = numerallya + 1;

    makeAnimatedLuaSprite('johna'..numerallya,'stages/tankmanBattlefield/tankmanKilled1',1800,200);
    addAnimationByPrefix('johna'..numerallya,'run','tankman running',24,true);
    addAnimationByPrefix('johna'..numerallya,'shot1','John Shot 1',24,false);
    addAnimationByPrefix('johna'..numerallya,'shot2','John Shot 2',24,false);
    setProperty('johna'..numerallya..'.flipX',false);
    playAnim('johna'..numerallya,'run');
    addOffset('johna'..numerallya, 'shot1', 150,150);
    addOffset('johna'..numerallya, 'shot2', 150,150);
    addLuaSprite('johna'..numerallya,false);

    doTweenX('teta1'..numerallya,'johna'..numerallya,1100,1/getProperty('playbackRate'));
    doTweenY('teta2'..numerallya,'johna'..numerallya,150,1/getProperty('playbackRate'));

    runTimer('eya1'..numerallya,0.895/getProperty('playbackRate'));
end

function onTimerCompleted(t)
    for i=0,100 do
        if t == 'eya1'..i then
            playAnim('johna'..i, 'shot'..getRandomInt(1,2));

            setProperty('johna'..i..'.alpha',.001);

            runTimer('eya2'..i,0.1/getProperty('playbackRate'));
        elseif t == 'eya2'..i then
            setProperty('johna'..i..'.alpha',1);

            runTimer('eya3'..i,0.09/getProperty('playbackRate'));
        elseif t == 'eya3'..i then
            setProperty('johna'..i..'.alpha',.001);

            runTimer('eya4'..i,0.09/getProperty('playbackRate'));

        elseif t == 'eya4'..i then
            setProperty('johna'..i..'.alpha',1);

            runTimer('eya5'..i,0.07/getProperty('playbackRate'));
        elseif t == 'eya5'..i then
            setProperty('johna'..i..'.alpha',.001);

            runTimer('eya6'..i,0.07/getProperty('playbackRate'));

        elseif t == 'eya6'..i then
            setProperty('johna'..i..'.alpha',1);

            runTimer('eya7'..i,0.05/getProperty('playbackRate'));
        elseif t == 'eya7'..i then
            setProperty('johna'..i..'.alpha',.001);

            runTimer('eya8'..i,0.05/getProperty('playbackRate'));

        elseif t == 'eya8'..i then
            setProperty('johna'..i..'.alpha',1);

            runTimer('eya9'..i,0.02/getProperty('playbackRate'));
        elseif t == 'eya9'..i then
            setProperty('johna'..i..'.alpha',.001);

            runTimer('eya10'..i,0.02/getProperty('playbackRate'));
        elseif t == 'eya10'..i then
            setProperty('johna'..i..'.alpha',1);

            runTimer('eya11'..i,0.01/getProperty('playbackRate'));
        elseif t == 'eya11'..i then
            removeLuaSprite('johna'..i); --for optimize
        end

        if t == 'ey1'..i then
            playAnim('john'..i, 'shot'..getRandomInt(1,2));

            setProperty('john'..i..'.alpha',.001);

            runTimer('ey2'..i,0.1/getProperty('playbackRate'));
        elseif t == 'ey2'..i then
            setProperty('john'..i..'.alpha',1);

            runTimer('ey3'..i,0.09/getProperty('playbackRate'));
        elseif t == 'ey3'..i then
            setProperty('john'..i..'.alpha',.001);

            runTimer('ey4'..i,0.09/getProperty('playbackRate'));

        elseif t == 'ey4'..i then
            setProperty('john'..i..'.alpha',1);

            runTimer('ey5'..i,0.07/getProperty('playbackRate'));
        elseif t == 'ey5'..i then
            setProperty('john'..i..'.alpha',.001);

            runTimer('ey6'..i,0.07/getProperty('playbackRate'));

        elseif t == 'ey6'..i then
            setProperty('john'..i..'.alpha',1);

            runTimer('ey7'..i,0.05/getProperty('playbackRate'));
        elseif t == 'ey7'..i then
            setProperty('john'..i..'.alpha',.001);

            runTimer('ey8'..i,0.05/getProperty('playbackRate'));

        elseif t == 'ey8'..i then
            setProperty('john'..i..'.alpha',1);

            runTimer('ey9'..i,0.02/getProperty('playbackRate'));
        elseif t == 'ey9'..i then
            setProperty('john'..i..'.alpha',.001);

            runTimer('ey10'..i,0.02/getProperty('playbackRate'));
        elseif t == 'ey10'..i then
            setProperty('john'..i..'.alpha',1);

            runTimer('ey11'..i,0.01/getProperty('playbackRate'));
        elseif t == 'ey11'..i then
            removeLuaSprite('john'..i); --for optimize
        end
    end

    if t == 'first' then
        runHaxeCode([[
            getVar('man').anim.play('talk1');
        ]])

        playSound(path..'stressCutscene');
    elseif t == 'cumfollow' then
        triggerEvent('Camera Follow Pos', gfCum[1], gfCum[2]);
        doTweenAlpha('lolol','blackpink',0.85,2.35);
        doTweenZoom('camTween','camGame',0.9 * 1.2 * 1.2,2.25,'quadInOut');
        runHaxeCode([[
            getVar('pico').anim.play('dieBitch');
            getVar('pico').anim.onComplete = () -> {
                getVar('pico').anim.play('picoAppears', true);
                getVar('pico').anim.onComplete = () -> {
                    getVar('pico').anim.play('picoEnd', true);
                    getVar('pico').anim.onComplete = () -> {
                        getVar('pico').kill();
                        game.gfGroup.visible = true;
                    }
                }

                game.getLuaObject('fakebf').visible = false;
                game.boyfriendGroup.visible = true;
                game.boyfriend.playAnim('hey', false);
                game.boyfriend.animation.finishCallback = function(name:String)
                {
                    if(name != 'idle')
                    {
                        game.boyfriend.playAnim('idle', true);
                        game.boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
                    }
                };
            }
        ]])
    elseif t == 'zoomback' then
        cancelTween('lolol');
        removeLuaSprite('blackpink');

        doTweenZoom('camTween','camGame',getProperty('defaultCamZoom'),0.7,'quadInOut');
        triggerEvent('Camera Follow Pos', gfCum[1], gfCum[2]+100);

        for i=0,5 do
            setProperty('tank'..i..'.y', getProperty('tank'..i..'.y')+100);
        end
    elseif t == 'tank' then
        runHaxeCode([[
            getVar('man').anim.play('talk2');
        ]]);
    elseif t == 'cumlol' then
        triggerEvent('Camera Follow Pos', 525, 525);
    elseif t == 'osk' then
        runHaxeCode([[
            game.boyfriend.playAnim('singUPmiss', true);
			game.boyfriend.animation.finishCallback = function(name:String)
			{
				if (name == 'singUPmiss')
				{
					game.boyfriend.playAnim('idle', true);
					game.boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
				}
			};
        ]])

        triggerEvent('Camera Follow Pos', 1115, 600);
        doTweenZoom('camTween','camGame',0.9 * 1.2 * 1.2,0.25,'elasticOut');
        setProperty('cameraSpeed',12);
    elseif t == 'zum' then
        doTweenZoom('camTween','camGame',0.835,0.01);
        triggerEvent('Camera Follow Pos',525,525);
    elseif t == 'endCutscene' then
        triggerEvent('Camera Follow Pos', '', '');
        setProperty('cameraSpeed',1);

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

local tankSteps = {1, 12, 22, 23, 40, 41, 50, 67, 74, 81, 89, 94, 102, 250, 260, 273, 
    278, 283, 288, 320, 340, 360, 377, 382, 390, 392, 396, 421, 432, 445, 452, 464, 466, 
    476, 480, 490, 512, 532, 550, 600, 632, 655, 666, 712, 743, 745, 767, 783, 800, 835, 855, 
    865, 877, 899, 934, 950, 967, 999, 1121, 1150, 1200, 1232, 1234, 1250, 1300, 1356, 1400, 1412};

function onStepHit()
    if getRandomBool(60) then
        for i = 0, #tankSteps do
            if curStep == tankSteps[i] then
                if getRandomBool(50) then
                    tankmen()
                else
                    tankmeh()
                end
            end
        end
    end
end