function goodNoteHit(id, dir, nt, isSus)
    if nt == 'Fake Punch' then
        triggerEvent('Play Animation', 'scam', 'bf');
        triggerEvent('Play Animation', 'cringe', 'dad');

        setProperty('boyfriend.specialAnim',true);
        setProperty('dad.specialAnim',true);
    end
end

function noteMiss(id, dir, nt, isSus)
    if nt == 'Fake Punch' then
        triggerEvent('Play Animation', 'scam', 'dad');
        setProperty('dad.specialAnim',true);
    end
end