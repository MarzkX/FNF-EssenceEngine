playVideo = true;

function onCreate()
    makeLuaSprite('blacking');
    makeGraphic('blacking',2000,2500,'0x000000');
    setObjectCamera('blacking','camOther');
end

function onEndSong()
	if isStoryMode then
		if playVideo then --Video cutscene plays first
            addLuaSprite('blacking',true) -- for realistic
			startVideo('2hotCutscene'); --Play video file from "videos/" folder
			playVideo = false;
			return Function_Stop; --Prevents the song from starting naturally
        end
	end
	return Function_Continue; --Played video and dialogue, now the song can start normally
end