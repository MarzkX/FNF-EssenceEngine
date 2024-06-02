playVideo = true;
playCutscene = true;

function onStartCountdown()
	if isStoryMode and not seenCutscene then
		if playVideo then --Video cutscene plays first
			startVideo('darnellCutscene'); --Play video file from "videos/" folder
			playVideo = false;
			return Function_Stop; --Prevents the song from starting naturally
        end

		if playCutscene then --Once the video ends it calls onStartCountdown again. Play dialogue this time
			startCutscene();
			return Function_Stop; --Prevents the song from starting naturally
		end
	end
	return Function_Continue; --Played video and dialogue, now the song can start normally
end

local picoPos = {getProperty('boyfriend.x')-58.5,getProperty('boyfriend.y')};
local picoLoxPos = {getProperty('boyfriend.x')-25,getProperty('boyfriend.y')};
local picoShootPos = {getProperty('boyfriend.x')-255,getProperty('boyfriend.y')-230};

function onCreate()
    makeAnimatedLuaSprite('pico','characters/Pico_Intro',picoPos[1],picoPos[2]);
    addAnimationByPrefix('pico','intro','Pico Gets Pissed',24,false);
    addAnimationByPrefix('pico','cutsceneShit','cutscene cock',24,false);
    addAnimationByPrefix('pico','shoot','shoot and return',24,false);
    playAnim('pico','intro');

    makeAnimatedLuaSprite('canFly','stages/phillyStreets/wked1_cutscene_1_can',425,300);
    addAnimationByPrefix('canFly','kick','can kick quick',18,false);
    addAnimationByPrefix('canFly','fly','can kicked up',24,false);
    setObjectOrder('canFly',getObjectOrder('cans'));
    setProperty('canFly.visible',false);

    makeAnimatedLuaSprite('explosion','stages/phillyStreets/SpraypaintExplosion',495,-210);
    addAnimationByPrefix('explosion','boom','Explosion 1 movie',24,false);
    setProperty('explosion.visible',false);

    makeLuaSprite('exp','stages/phillyStreets/explosion',800,150);
    scaleObject('exp', 0.9, 0.9)
    setProperty('exp.angle',15)
    setProperty('exp.alpha',.001);

    makeLuaSprite('blacking');
    makeGraphic('blacking',2000,2500,'0x000000');
    setObjectCamera('blacking','camOther');

    if isStoryMode and not seenCutscene then
        addLuaSprite('pico',true);
        addLuaSprite('canFly',true);
        addLuaSprite('explosion',true);
        addLuaSprite('exp',true);
        addLuaSprite('blacking',true);
        setProperty('boyfriendGroup.visible',false);
    end
end

local cutsceneShit = 2;

function startCutscene()
    triggerEvent('Play Animation', 'danceLeft', 'gf');
    playAnim('pico','intro');

    runTimer('camera',0.1);
    runTimer('fadeMusic',0.7);
    runTimer('darnellShit',cutsceneShit);
    runTimer('darnellStart',cutsceneShit+3)
    runTimer('fire',cutsceneShit+3.1);
    runTimer('picoWoah',cutsceneShit+4);
    runTimer('canKickUp',cutsceneShit+4.4);
    runTimer('canBye(',cutsceneShit+4.9);
    runTimer('BOOM',cutsceneShit+5.1);
    runTimer('lol',cutsceneShit+5.175);
    runTimer('darnellLaught',cutsceneShit+5.9);
    runTimer('neneLaught',cutsceneShit+6.2);
    runTimer('songStart',cutsceneShit+8);
    runTimer('picoReturn',cutsceneShit+9.5);
end

local laughNum = 0;

function onUpdate(e)
    if keyboardJustPressed('Y') then
        restartSong();
    end

    if playCutscene then
        if getProperty('dad.animation.curAnim.name') == 'idle' and getProperty('dad.animation.curAnim.finished') then
            triggerEvent('Play Animation', 'idle', 'dad');
        end

        if getProperty('gf.animation.curAnim.name') == 'danceLeft' and getProperty('gf.animation.curAnim.finished') then
            triggerEvent('Play Animation', 'danceRight', 'gf');
        end

        if getProperty('gf.animation.curAnim.name') == 'danceRight' and getProperty('gf.animation.curAnim.finished') then
            triggerEvent('Play Animation', 'danceLeft', 'gf');
        end

        if getProperty('dad.animation.curAnim.name') == 'start' and getProperty('dad.animation.curAnim.finished') then
            triggerEvent('Play Animation', 'start-loop','dad');
        end
    
        if ((getProperty('gf.animation.curAnim.name') == 'pfw' and getProperty('gf.animation.curAnim.finished') 
                or getProperty('gf.animation.curAnim.name') == 'laugh') and getProperty('gf.animation.curAnim.curFrame') == 5) and laughNum < 5 then
            laughNum = laughNum + 1;
    
            triggerEvent('Play Animation', 'laugh', 'gf');
        elseif getProperty('gf.animation.curAnim.name') == 'laugh' and getProperty('gf.animation.curAnim.finished') and laughNum > 4 then
            triggerEvent('Play Animation', 'laugh1','gf');
        end
    
        if getProperty('explosion.animation.curAnim.finished') then
            setProperty('explosion.visible',false);
        end
    end
end

function onTimerCompleted(t)
    if t == 'camera' then
        triggerEvent('Camera Follow Pos', 1200, 500);
        setProperty('camGame.zoom',1.05);
    elseif t == 'fadeMusic' then
        doTweenAlpha('blackingTween','blacking',0,0.66);
        playMusic('cutscene/darnellCanCutscene');
    elseif t == 'darnellShit' then
        setProperty('cameraSpeed',0.9);
        doTweenZoom('camTween','camGame',getProperty('defaultCamZoom'),1.25,'quadOut');
        triggerEvent('Camera Follow Pos', 920, 450);
    elseif t == 'darnellStart' then
        setProperty('cameraSpeed',1.5);
        playSound('stages/phillyStreets/Darnell_Lighter')
        triggerEvent("Play Animation", 'start', 'dad');
    elseif t == 'fire' then
        playSound('stages/phillyStreets/fuse_burning', 0.7, 'fuse');
    elseif t == 'picoWoah' then
        setProperty('pico.x',picoLoxPos[1]);
        setProperty('pico.y',picoLoxPos[2]);
        playAnim('pico','cutsceneShit');
        playSound('stages/phillyStreets/Gun_Prep');
        triggerEvent('Camera Follow Pos', 950, 450);
    elseif t == 'canKickUp' then
        setProperty('canFly.visible',true);
        playAnim('canFly','fly');
        setProperty('cameraSpeed',1);
        triggerEvent('Play Animation', 'kickUp', 'dad');
        playSound('stages/phillyStreets/Kick_Can_UP');
    elseif t == 'canBye(' then
        playAnim('canFly','kick');
        playSound('stages/phillyStreets/Kick_Can_FORWARD');
        triggerEvent('Play Animation', 'attack', 'dad');
    elseif t == 'BOOM' then
        setProperty('pico.x',picoShootPos[1]);
        setProperty('pico.y',picoShootPos[2]);
        playAnim('pico','shoot');
        playAnim('explosion','boom');
        setProperty('exp.alpha',1);
        setProperty('blackfuck.alpha',1);
        doTweenAlpha('blackTween','blackfuck',.001,1);
        stopSound('fuse');
        setProperty('explosion.visible',true);
        setProperty('canFly.visible',false);
        playSound('stages/phillyStreets/shot'..getRandomInt(1,4));
    elseif t == 'lol' then
        setProperty('exp.alpha',.001);
    elseif t == 'darnellLaught' then
        triggerEvent('Camera Follow Pos', 920, 450);
        playSound('cutscene/darnell_laugh');
        triggerEvent('Play Animation', 'laugh', 'dad');
    elseif t == 'neneLaught' then
        playSound('cutscene/nene_laugh');
        triggerEvent('Play Animation', 'pfw', 'gf');
    elseif t == 'songStart' then
        triggerEvent('Camera Follow Pos', '', '');
        playCutscene = false;
        startCountdown();
    elseif t == 'picoReturn' then
        removeLuaSprite('pico');
        setProperty('boyfriendGroup.visible',true);
    end
end