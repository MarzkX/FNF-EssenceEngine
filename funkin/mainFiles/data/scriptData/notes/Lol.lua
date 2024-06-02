function goodNoteHit(id, dir, nt, isSus)
    if nt == 'Lol' then
        setObjectOrder('dadGroup', 10)
        triggerEvent('Play Animation', 'angry', 'bf');
        triggerEvent('Play Animation', 'angry', 'dad');

        setProperty('dad.specialAnim',true);
        setProperty('boyfriend.specialAnim',true);
    end
end

function noteMiss(id, dir, nt, isSus)
    if nt == 'Lol' then
        setObjectOrder('dadGroup', 14)
        triggerEvent('Play Animation', 'hurt2', 'bf');
        triggerEvent('Play Animation', 'punchHigh'..getRandomInt(1,2), 'dad');

        setProperty('dad.specialAnim',true);
        setProperty('boyfriend.specialAnim',true);
    end
end