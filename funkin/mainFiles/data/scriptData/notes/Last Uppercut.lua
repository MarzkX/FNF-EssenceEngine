isGood = false;

function goodNoteHit(id, dir, nt, isSus)
    if nt == 'Last Uppercut' then
        isGood = true;

        setObjectOrder('dadGroup', 7)

        cameraShake('camGame', 0.002, 0.4);

        triggerEvent('Play Animation', 'uppercut', 'bf');
        triggerEvent('Play Animation', 'uppercuted', 'dad');

        setProperty('boyfriend.specialAnim',true);
        setProperty('dad.specialAnim',true);

        triggerEvent('Alt Idle Animation', '-up', 'bf');
        triggerEvent('Alt Idle Animation', '-up', 'dad');

        runTimer('pleaseHoldAnim',0.1);
    end
end

function noteMiss(id, dir, nt, isSus)
    if nt == 'Last Uppercut' then
        setObjectOrder('dadGroup', 7)

        cameraShake('camGame', 0.002, 0.4);

        triggerEvent('Play Animation', 'uppercut', 'bf');
        triggerEvent('Play Animation', 'dodge', 'dad');

        setProperty('boyfriend.specialAnim',true);
        setProperty('dad.specialAnim',true);
    end
end