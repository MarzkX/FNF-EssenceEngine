phillyLightsColors = {
	'31A2FD',
	'31FD8C',
	'FB33F5',
	'FD4531',
	'FBA633'
};
curLight = 0;

globalTrainWork = true;
trainMoving = false;
trainFrameTiming = 0;
startedMoving = false;

trainCars = 8;
trainFinishing = false;
trainCooldown = 0;

function onCreate()
    makeLuaSprite('gradient', 'stages/phillyTrain/gradient', 0,180);
    scaleObject('gradient', 2000, getProperty('gradient.scale.y')+0.2);
    setObjectOrder('gradient', getObjectOrder('behindTrain'));
    setProperty('gradient.alpha',.001);
    if flashingLights then
        addLuaSprite('gradient',false);
    end

    makeLuaSprite('train', 'stages/phillyTrain/train', 2000, 360);
    setObjectOrder('train', getObjectOrder('behindTrain')+1);
    addLuaSprite('train',false);

    precacheSound('stages/phillyTrain/train_passes')
end

eventPushed = false;
eventFirsted = false;

function onStepHit()
    if eventPushed then
        spawnParticle();
    end
end

function onEvent(n, v1, v2)
    if n == 'Philly Glow' then
        if v1 == '0' then
            eventPushed = false;
            globalTrainWork = true;

            triggerEvent('Add Camera Zoom', 0.4, 0.05);

            setProperty('bg.visible',true);
            setProperty('gradient.alpha',0.001);

            if flashingLights then
                cameraFlash('camGame', phillyLightsColors[curLight], 0.4);
            end

            for i=0,71 do
                setProperty('particle'..i..'.visible',false);
                setProperty('particle2'..i..'.visible',false);
            end

            setProperty('city.color', getColorFromHex('ffffff'))
            setProperty('boyfriendGroup.color', getColorFromHex('ffffff'));
            setProperty('dadGroup.color',getColorFromHex('ffffff'));
            setProperty('gfGroup.color', getColorFromHex('ffffff'));
            setProperty('behindTrain.color', getColorFromHex('ffffff'));
            setProperty('street.color', getColorFromHex('ffffff'));
            return;
        end

        if not eventFirsted then
            triggerEvent('Add Camera Zoom', 0.4, 0.05);

            eventFirsted = true;
        end

        if v1 == '1' then
            if flashingLights then
                cameraFlash('camGame', phillyLightsColors[curLight], 0.4);
            end
        end

        if v1 == '2' then
            setProperty('gradient.alpha',1);
            doTweenAlpha('gradTween','gradient',0.15,0.4,'quadOut');
        end 

        setProperty('bg.visible',false);
        eventFirsted = true;
        eventPushed = true;
        globalTrainWork = false;
    end
end

function onUpdate(elapsed)
    setProperty('window.alpha', getProperty('window.alpha') - (crochet / 1000) * elapsed * 1.5);

    for i=0,71 do
        local songPos = getPropertyFromClass('funkin.backend.Conductor', 'songPosition');

        setProperty('particle'..i..'.x', (i*20) + math.sin((songPos/1000)*(bpm/21))*12);
        setProperty('particle2'..i..'.x', (i*20) + math.sin((songPos/-1000)*(bpm/21))*12);

        setProperty('particle'..i..'.color', getProperty('window.color'))
        setProperty('particle2'..i..'.color', getProperty('window.color'))
    end

    if eventPushed then
        setProperty('boyfriendGroup.color', getProperty('window.color'));
        setProperty('dadGroup.color', getProperty('window.color'));
        setProperty('gfGroup.color', getProperty('window.color'));

        setProperty('city.color', getProperty("window.color"))
        setProperty('behindTrain.color', getProperty('window.color'));
        setProperty('street.color', getProperty('window.color'));
    end

    setProperty('gradient.color',getProperty('window.color'));

    if trainMoving then
        if not globalTrainWork then
            stopSound('trainSound');
            return;
        end

		trainFrameTiming = trainFrameTiming + elapsed;

		if trainFrameTiming >= 1 / 24 then
			updateTrainPos();
			trainFrameTiming = 0;
		end
	end
end

function onBeatHit()
    if curBeat % 4 == 0 then
		for i = 0, 4 do
			setProperty('window.visible', false)
		end

		curLight = getRandomInt(1, #phillyLightsColors);
		setProperty('window.visible', true)
		setProperty('window.alpha', 1)
		setProperty('window.color', getColorFromHex(phillyLightsColors[curLight]));
	end

    if not trainMoving then
        if not globalTrainWork then
            return;
        end

		trainCooldown = trainCooldown + 1;
	end

    if globalTrainWork then
        if curBeat % 8 == 4 and getRandomInt(0, 9) <= 3 and not trainMoving and trainCooldown > 8 then
            trainCooldown = getRandomInt(-4, 0);
            trainStart();
        end
    end
end

function trainStart()
	trainMoving = true;
	playSound('stages/phillyTrain/train_passes', 1, 'trainSound');
end

function updateTrainPos()
	if getSoundTime('trainSound') >= 4700 then
		startedMoving = true;
		characterPlayAnim('gf', 'hairBlow');
		setProperty('gf.specialAnim', true);
	end

	if (startedMoving) then
		trainX = getProperty('train.x') - 400;
		setProperty('train.x', trainX);

		if trainX < -2000 and not trainFinishing then
			setProperty('train.x', -1150);
			trainX = -1150;
			trainCars = trainCars - 1;

			if trainCars <= 0 then
				trainFinishing = true;
			end
		end

		if trainX < -4000 and trainFinishing then
			trainReset();
		end
	end
end

function trainReset()
	setProperty('gf.danced', false); --Sets head to the correct position once the animation ends
	playAnim('gf', 'hairFall');
	setProperty('gf.specialAnim', true); --Prevents it from being reset by the idle animation
	setProperty('train.x', screenWidth + 275);
	trainMoving = false;
	trainCars = 8;
	trainFinishing = false;
	startedMoving = false;
end

local particleNum = 0;

function spawnParticle()
    particleNum = particleNum + getRandomInt(1,10);

    if particleNum > 70 then
        particleNum = 0;
    end

    makeLuaSprite('particle'..(particleNum+1), 'stages/phillyTrain/particle', 0, 600);
    setScrollFactor('particle'..(particleNum+1), 0.6, 0.6);
    setObjectOrder('particle'..(particleNum+1),getObjectOrder('street'));
    addLuaSprite('particle'..(particleNum+1), false);

    makeLuaSprite('particle2'..(particleNum+1), 'stages/phillyTrain/particle', 0, 600);
    setScrollFactor('particle2'..(particleNum+1), 0.6, 0.6);
    setObjectOrder('particle2'..(particleNum+1),getObjectOrder('street'));
    addLuaSprite('particle2'..(particleNum+1), false);

    doTweenY('particleTween'..particleNum, 'particle'..(particleNum+1), -200, getRandomFloat(3,4), 'cubeOut');
    doTweenAlpha('fartEffect'..particleNum, 'particle'..(particleNum+1), 0, getRandomFloat(3,4), 'quadOut');

    doTweenY('particleTween2'..particleNum, 'particle2'..(particleNum+1), -200, getRandomFloat(8,10), 'cubeOut');
    doTweenAlpha('fartEffect2'..particleNum, 'particle2'..(particleNum+1), 0, getRandomFloat(4,6), 'quadOut');
end

function onTweenCompleted(t)
    for i=0,100 do
        if t == 'fartEffect'..i then
            removeLuaSprite('particle'..i);
        end

        if t == 'fartEffect2'..i then
            removeLuaSprite('particle2'..i);
        end
    end
end