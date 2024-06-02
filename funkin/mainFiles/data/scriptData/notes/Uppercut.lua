function goodNoteHit(id, dir, nt, isSus)
    if nt == 'Uppercut' then
        setObjectOrder('dadGroup', 10)

        if dir == 3 or dir == 1 then
            triggerEvent('Play Animation', 'before', 'bf');
        else
            cameraShake('camGame', 0.002, 0.4);

            triggerEvent('Play Animation', 'uppercut', 'bf');
            triggerEvent('Play Animation', 'uppercuted', 'dad');
        end
    end
end

function noteMiss(id, dir, nt, isSus)
    if nt == 'Uppercut' then
        setObjectOrder('dadGroup', 14)

        if dir == 3 or dir == 1 then
            triggerEvent('Play Animation', 'before', 'dad');
        else
            cameraShake('camGame', 0.002, 0.4);

            triggerEvent('Play Animation', 'uppercut', 'dad');
            triggerEvent('Play Animation', 'uppercuted', 'bf');
        end
    end
end

function opponentNoteHit(id, dir, nt, isSus)
    if nt == 'Uppercut' then
        setObjectOrder('dadGroup', 14)

        if dir == 0 or dir == 1 then
            triggerEvent('Play Animation', 'before', 'dad');
        else
            cameraShake('camGame', 0.002, 0.4);

            triggerEvent('Play Animation', 'uppercut', 'dad');
            triggerEvent('Play Animation', 'uppercuted', 'bf');
        end
    end
end