local notePressed = false;

function goodNoteHit(id, dir, ntype, isSus)
    if ntype == 'BF Cheer' then
        triggerEvent('Change Character', 'bf', 'bf-cheer');
        triggerEvent('Play Animation', 'hey', 'bf');
    end
end

function onUpdate(e)
    if getProperty('boyfriend.animation.curAnim.name') == 'hey' and
        getProperty('boyfriend.animation.curAnim.finished') then
        triggerEvent('Change Character', 'bf', 'bf');
    end
end