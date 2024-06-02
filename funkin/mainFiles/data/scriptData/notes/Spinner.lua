local what = {
    'Low',
    'High'
};

function goodNoteHit(id, dir, nt, isSus)
    if nt == 'Spinner' then
        punch = what[getRandomInt(1,2)]..''..getRandomInt(1,2);

            if punch == 'Low1' then
                theAnim('bf', 'punchLow1');

                theAnim('dad', 'spin-my-baby-loop');
            elseif punch == 'Low2' then
                theAnim('bf', 'punchLow2');

                theAnim('dad', 'spin-my-baby-loop');

            end
    
            if punch == 'High1' then
                theAnim('bf', 'punchHigh1');

                theAnim('dad', 'spin-my-baby-loop');

            elseif punch == 'High2' then
                theAnim('bf', 'punchHigh2');

                theAnim('dad', 'spin-my-baby-loop');

            end

            setObjectOrder('dadGroup',10);
    end
end

function noteMiss(id, dir, nt, isSus)
    if nt == 'Spinner' then
        punch = what[getRandomInt(1,2)]..''..getRandomInt(1,2);

            if punch == 'Low1' then
                theAnim('dad', 'punchLow1');

                theAnim('bf', 'spin-my-baby-loop');
            elseif punch == 'Low2' then
                theAnim('dad', 'punchLow2');

                theAnim('bf', 'spin-my-baby-loop');

            end
    
            if punch == 'High1' then
                theAnim('dad', 'punchHigh1');

                theAnim('bf', 'spin-my-baby-loop');

            elseif punch == 'High2' then
                theAnim('dad', 'punchHigh2');

                theAnim('bf', 'spin-my-baby-loop');

            end

            setObjectOrder('dadGroup',14);
    end
end

function theAnim(m, a)
    triggerEvent('Play Animation', a, m);
    
    if m == 'bf' then
        setProperty('boyfriend.specialAnim',true);
    else
        setProperty('boyfriend.specialAnim',true);
        setProperty('dad.specialAnim',true);
    end
end