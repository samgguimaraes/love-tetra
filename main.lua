function love.load()
    input = require('input')
    tetram = require('tetramino')
    _px = 5
    _py = 1
    px = _px
    py = _py
    _pr = 1
    pr = _pr
    pid = ''
    nx = 5
    ny = -2
    nid = ''
    
    scale = 3
    max_x = 10
    max_y = 22
    _grid_size = {max_x, max_y}
    _block_size = 25 * scale
    _border = 1 * scale
    _header_size = 4
    game_grid = setup_grid(_grid_size[1], _grid_size[2])

    _base_step = 1
    step = _base_step
    _last_step = 0


    back_c = {0.5, 0.5, 0.5}

    love.window.setMode((_grid_size[1] + 2) * _block_size,
                        (_grid_size[2] + 1 + _header_size) * _block_size)
    love.graphics.setBackgroundColor(0.95, 0.95, 0.95)

    next_p()
    next_p()
end


function love.update(ts)
    input.update(ts)
    if input.get_key('left') then move_piece(-1, 0) end
    if input.get_key('right') then move_piece(1, 0) end
    if input.get_key('up') then rotate_p() end
    if input.get_key('down') then fall() end
 --   if input.get_key('a1') then hit() end
    if input.get_key('a2') then rotate_p() end

    update_step(ts)
end


function love.draw()
    --Drawing the background
    d_background() 
    --Drawing the game state
    d_grid(game_grid)
    --Drawing FX layer
    d_grid(fx)
    --Drawing next piece
    draw_piece(nid, 2, nx, ny, 'nxt')
    --Drawing active piece
    draw_piece(pid, pr, px, py)
    --Drawing UI
    ui_d()
end


function update_step(ts)
    local fall_step = 1
    _last_step = _last_step + ts
    if _last_step >= step then
        if valid_pos(pid, pr, px, py + fall_step) then
            move_piece(0, fall_step)
            _last_step = 0
            return true
        else
            hit()
            return false
        end
    end
end


function fall()
    local can_fall = true
    while can_fall do
        can_fall = update_step(step)
    end
end

function setup_grid(sx, sy)
    local grid = {}
    for x = 1, sx do
        grid[x] = {}
        for y = 1, sy do
            grid[x][y] = tetram.back
        end
    end

    return grid
end

function ui_d()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('Tetramino/Тетрамино', _block_size, _block_size)
end


function valid_pos(id, rot, x, y)
    local shape = tetram.shape[id][rot]
    for j, l in ipairs(shape) do
        for i, c in ipairs(l) do
            if c ~= tetram.empty then
                m = i + x - 1
                n = j + y - 1
                if m < 1 or n < 1 then return false end
                if m > max_x or n > max_y then return false end
                if game_grid[m][n] ~= tetram.back then
                    return false
                end
            end
        end
    end
    return true
end


function next_p()
    local n = math.random(1, #tetram.ids)
    pid = nid
    nid = tetram.ids[n]
    px = _px
    py = _py
    pr = _pr
    _last_step = 0
end


function rotate_p()
    if pid or false then else return end
    local r_inc = 1
    r_inc = pr + 1
    if r_inc > #tetram.shape[pid] then
        r_inc = 1
    end

    if valid_pos(pid, r_inc, px, py) then
        pr = r_inc
    end
end


function move_piece(x, y)
    if valid_pos(pid, pr, px + x, py + y) then
        px = px + x
        py = py + y
    end
end


function hit()
    bake_piece(pid, pr, px, py)
    next_p()
end

function bake_piece(id, r, x, y)
    local shape = tetram.shape[id][r]
    for j, l in ipairs(shape) do
        for i, c in ipairs(l) do
            if c ~= tetram.empty then
                m = i + x - 1
                n = j + y - 1
                local invalid =  m < 1 or n < 1 or  m > max_x or n > max_y
                if not invalid then 
                    game_grid[m][n] = c
                end
            end
        end
    end
end


function d_grid(grid_map)
    if grid_map or false then else return end
    for x, l in ipairs(grid_map) do
        for y, k in ipairs(l) do
            local c = tetram.colour[k]
            d_square(x, y, c)
        end
    end
end


function d_background()
    love.graphics.setColor(back_c[1], back_c[2], back_c[3])
    love.graphics.rectangle('fill',
                            _block_size - _border,
                            (_header_size * _block_size) - _border,
                            _grid_size[1]*_block_size + _border,
                            _grid_size[2]*_block_size + _border)
end


function d_square(x, y, c)
    if c or false then else return end
    y = y + _header_size - 1
    love.graphics.setColor(c[1], c[2], c[3])
    love.graphics.rectangle('fill', 
                            x * _block_size, 
                            y * _block_size, 
                            _block_size - _border,
                            _block_size - _border)
end


function draw_piece(id, rot, px, py, colour)
    local shape = tetram.shape[id]
    if shape or false then else return end
    if rot > #shape then rot = 1 end
    shape = shape[rot]
    for y, l in ipairs(shape) do
        for x, c in ipairs(l) do
            if c ~= '' then c = colour or c end
            d_square(px + x - 1, py + y - 1, tetram.colour[c])
        end
    end
end

