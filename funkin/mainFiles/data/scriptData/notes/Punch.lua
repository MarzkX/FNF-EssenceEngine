local what = {
    'Low',
    'High'
};

local who = {
    'dad',
    'bf'
};

local whatAnim = {
    'block',
    'dodge'
};

local whatAnimDad = {
    'hurt1',
    'hurt2',
    'block',
    'dodge'
};

local hmm = '';
local punch = '';
local dadGroup = 0;
local gfGroup = 0;

function onCreatePost()
    dadGroup = getObjectOrder('dadGroup');
    gfGroup = getObjectOrder('gfGroup');

    setObjectOrder('boyfriendGroup',12);
    setObjectOrder('dadGroup',10);

    setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'characterName', 'pico-blazin');
    setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'deathSoundName', 'gameover/fnf_loss_sfx-pico-gutpunch');
    setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'loopSoundName', 'gameover/gameOver-pico');
    setPropertyFromClass('funkin.ui.ingame.GameOverSubstate', 'endSoundName', 'gameover/gameOverEnd-pico');

    makeLuaText('yess', ''..dadGroup..'\n'..gfGroup, 500, 0, 0);
    setObjectCamera('yess','camOther');
    addLuaText('yess');

    for i=0,4 do
        setProperty('playerStrums.members['..i..'].x',(i*110)+420);
    end
end

function onUpdatePost(e)
    for i=0,4 do
        setProperty('opponentStrums.members['..i..'].alpha',.001);
    end
end

local thePunchNum = 0;

function goodNoteHit(id, dir, nt, isSus)
    if nt == 'Punch' then
        if thePunchNum > 1 then
            thePunchNum = 0;
        end

        thePunchNum = thePunchNum + 1;

        hmm = who[thePunchNum];

        if hmm == 'dad' then
            theAnim('dad', 'punch'..what[thePunchNum]..''..thePunchNum);
            theAnim('bf', whatAnim[thePunchNum])

            setObjectOrder('dadGroup',14);
        else
            punch = what[thePunchNum]..''..thePunchNum;

            if punch == 'Low1' then
                theAnim('bf', 'punchLow1');

                if getRandomBool(50) then
                    theAnim('dad', 'hurt2');
                else
                    theAnim('dad', whatAnim[thePunchNum]);
                end
            elseif punch == 'Low2' then
                theAnim('bf', 'punchLow2');

                if getRandomBool(50) then
                    theAnim('dad', 'hurt2');
                else
                    theAnim('dad', whatAnim[thePunchNum]);
                end
            end
    
            if punch == 'High1' then
                theAnim('bf', 'punchHigh1');

                if getRandomBool(50) then
                    theAnim('dad', 'hurt1');
                else
                    theAnim('dad', whatAnim[thePunchNum]);
                end
            elseif punch == 'High2' then
                theAnim('bf', 'punchHigh2');

                if getRandomBool(50) then
                    theAnim('dad', 'hurt1');
                else
                    theAnim('dad', whatAnim[thePunchNum]);
                end
            end

            setObjectOrder('dadGroup',10);
        end

        setProperty('boyfriend.specialAnim',true);
        setProperty('dad.specialAnim',true);
    end
end

function opponentNoteHit(id, dir, nt, isSus)
    if nt == 'Punch' then
        punch = what[getRandomInt(1,2)]..''..getRandomInt(1,2);

        if punch == 'Low1' then
            theAnim('dad', 'punchLow1');
            theAnim('bf', 'hurt1');
        elseif punch == 'Low2' then
            theAnim('dad', 'punchLow2');
            theAnim('bf', 'hurt1');
        end

        if punch == 'High1' then
            theAnim('dad', 'punchHigh1');
            theAnim('bf', 'hurt2');
        elseif punch == 'High2' then
            theAnim('dad', 'punchHigh2');
            theAnim('bf', 'hurt2');
        end

        setObjectOrder('dadGroup',14);

        setProperty('boyfriend.specialAnim',true);
        setProperty('dad.specialAnim',true);
    end
end

function noteMiss(id, dir, nt, isSus)
    if nt == 'Punch' then
        punch = what[getRandomInt(1,2)]..''..getRandomInt(1,2);

        if punch == 'Low1' then
            theAnim('dad', 'punchLow1');
            theAnim('bf', 'hurt1');
        elseif punch == 'Low2' then
            theAnim('dad', 'punchLow2');
            theAnim('bf', 'hurt1');
        end

        if punch == 'High1' then
            theAnim('dad', 'punchHigh1');
            theAnim('bf', 'hurt2');
        elseif punch == 'High2' then
            theAnim('dad', 'punchHigh2');
            theAnim('bf', 'hurt2');
        end

        setObjectOrder('dadGroup',14);

        setProperty('boyfriend.specialAnim',true);
        setProperty('dad.specialAnim',true);
    end
end

function theAnim(m, a)
    triggerEvent('Play Animation', a, m);
end