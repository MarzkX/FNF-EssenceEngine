--DONT TOUCH!!

songs = {
    "Darnell",
    "Lit-Up",
    "2Hot"
};

local middle = true;
local opponent = false;

function onCreate()
    setPropertyFromClass('engine.backend.ClientPrefs', 'data.splashSkin', 'Psych');
end

local returning = false;
local theAnim = false;

function onUpdate(e)
    for i=0,#songs do
        if songName == songs[i] then
            if getProperty('health') < 0.4 and not returning then
                characterPlayAnim('gf', 'yes');
                setProperty('gf.specialAnim', true);
        
                triggerEvent('Alt Idle Animation', 'gf', '-knife');
        
                returning = true;
            elseif getProperty('health') > 0.4 and returning then
                characterPlayAnim('gf', 'no');
                setProperty('gf.specialAnim', true);
        
                triggerEvent('Alt Idle Animation', 'gf', '');
        
                returning = false;
            end
        end
    end
end

function opponentNoteHit(id, dir, nt, isSus) --i'm lazy for fixing this in source... :/
    for i=0,getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'otherAnim') == '' or getPropertyFromGroup('unspawnNotes', i, 'otherAnim') == nil then
            if dir == 0 and nt ~= 'No Animation' then
                triggerEvent('Play Animation', 'singLEFT'..getPropertyFromGroup('unspawnNotes', 0, 'animSuffix'), 'dad');
            elseif dir == 1 and nt ~= 'No Animation' then
                triggerEvent('Play Animation', 'singDOWN'..getPropertyFromGroup('unspawnNotes', 1, 'animSuffix'), 'dad');
            elseif dir == 2 and nt ~= 'No Animation'then
                triggerEvent('Play Animation', 'singUP'..getPropertyFromGroup('unspawnNotes', 2, 'animSuffix'), 'dad');
            elseif dir == 3 and nt ~= 'No Animation' then
                triggerEvent('Play Animation', 'singRIGHT'..getPropertyFromGroup('unspawnNotes', 3, 'animSuffix'), 'dad');
            end
        else
            triggerEvent('Play Animation', getPropertyFromGroup('unspawnNotes', i, 'otherAnim'), 'dad');
        end
    end
end 