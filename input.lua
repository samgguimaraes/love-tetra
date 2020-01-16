local input = {}

input.cooldown = 0.2
input.keys = 
{
    left = {'left'},
    right = {'right'},
    up = {'up'},
    down = {'down'},
    a1 = {'space', 'z'},
    a2 = {'x', 'return'},
    cancel = {'escape', 'c'}
}

input.keydown = {}
for _, k in pairs(input.keys) do 
    input.keydown[k] = 0
end

--- Run the check up to see if any key state has changed
-- @param ts time step since last update
function input.update(ts)
    for n, ks in pairs(input.keys) do
        local down = false
        for _, k in pairs(ks) do
            if love.keyboard.isDown(k) then
                down = true
            end
        end
        if down then
            input.keydown[n] = input.keydown[n] + ts
        else
            input.keydown[n] = 0
        end
    end
end


--- Put a timeout on the key avoiding it to be triggered again
-- @param n key to be slept
function input.key_sleep(n)
    if input.keydown[n] > 0 then
        input.keydown[n] = -input.cooldown
    end
end


--- Return if a key is down and put it to sleep
-- @param n key to be checked
function input.get_key(n)
    isdown = input.keydown[n] > 0
    input.key_sleep(n)
    return isdown
end

return input
