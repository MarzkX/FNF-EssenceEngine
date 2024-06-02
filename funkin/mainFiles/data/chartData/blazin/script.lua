local rainMediumSteps = {384};
local rainHighSteps = {128};
local rainLowSteps = {448};

function onStepHit()
    for i=0,#rainMediumSteps do
        if curStep == rainMediumSteps[i] then
            setShaderFloat("shaderSpr", "uIntensity",0.35);
        end
    end

    for i=0,#rainHighSteps do
        if curStep == rainLowSteps[i] then
            setShaderFloat("shaderSpr", "uIntensity",0.4);
        end
    end

    for i=0,#rainLowSteps do
        if curStep == rainHighSteps[i] then
            setShaderFloat("shaderSpr", "uIntensity",0.3);
        end
    end
end

function onCreate()
    makeLuaSprite('blacking');
    makeGraphic('blacking',2000,2500,'0x000000');
    setObjectCamera('blacking','camOther');
end

playVideo = true;

function onEndSong()
	if isStoryMode then
		if playVideo then --Video cutscene plays first
            addLuaSprite('blacking',true) -- for realistic
			startVideo('blazinCutscene'); --Play video file from "videos/" folder
			playVideo = false;
			return Function_Stop; --Prevents the song from starting naturally
        end
	end
	return Function_Continue; --Played video and dialogue, now the song can start normally
end