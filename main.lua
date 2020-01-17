function love.load()
    input = require('input')
    tetram = require('tetramino')

    math.randomseed(os.time())

    _px = 5
    _py = 1
    px = _px
    py = _py
    _pr = 1
    pr = _pr
    pid = ''
    nx = 7
    ny = -2
    nid = ''

    _running = true
    _paused = false

    score = 0
    
    scale = 3
    _max_scale = 5

    max_x = 10
    max_y = 22
    _grid_size = {max_x, max_y}
    _base_block_size = 25
    _header_size = 4

    set_sizes()

    game_grid = setup_grid(_grid_size[1], _grid_size[2])

    _base_step = 1
    level = 1
    step = _base_step
    _last_step = 0
    fall_size = 1

    fx = {}

    back_c = {0.5, 0.5, 0.5}

    love.graphics.setBackgroundColor(0.95, 0.95, 0.95)
    font = love.graphics.newFont('fonts/cyrillic_pixel-7.ttf', 12)

    next_p()
    next_p()
    add_score(0)

--    local last_level = level
--   local last_score = 0
--    while level <= 10 do
--        score = score + 1
--        add_score(0)
--        if level ~= last_level then
--            one_score = (level + 4)
--            d_score = score - last_score
--            print(level, score, one_score, d_score, d_score/one_score)
--            last_score = score
--        end
--        last_level = level
--    end
end


function love.update(ts)
    input.update(ts)
    if input.get_key('cancel') then pause() end

    if _running and not _paused then
        if input.get_key('left') then move_p(-1, 0) end
        if input.get_key('right') then move_p(1, 0) end
        if input.get_key('up') then rotate_p() end
        if input.get_key('down') then fall() end
        if input.get_key('a2') then rotate_p() end
        if input.get_key('f5') then set_scale(scale - 1) end
        if input.get_key('f6') then set_scale(scale + 1) end
        update_step(ts)
    end
end


function love.draw()
    --Drawing the background
    d_background() 
    --Drawing the game state
    d_grid(game_grid)
    --Drawing next piece
    d_piece(nid, 2, nx, ny, 'nxt')
    --Drawing active piece
    d_piece(pid, pr, px, py)
    --Drawing FX layer
    d_fx()
    --Drawing UI
    ui_d()
end


function update_step(ts)
    local no_hit = true
    _last_step = _last_step + ts
    if _last_step >= step then
        if valid_pos(pid, pr, px, py + fall_size) then
            move_p(0, fall_size)
            _last_step = 0
        else
            hit()
            no_hit = false
            local lines_clear = clear_lines(game_grid) 
            if lines_clear > 0 then
                add_score(lines_clear)
                fall_lines(game_grid)
            end
        end
    end

    return no_hit
end

function pause()
    _paused = not _paused
end


function fall()
    local can_fall = valid_pos(pid, pr, px, py + fall_size)
    while can_fall do
        move_p(0, fall_size)
        can_fall = valid_pos(pid, pr, px, py + fall_size)
    end
    _last_step = 0
end


function setup_grid(sx, sy)
    local grid = {}
    for y = 1, sy do
        grid[y] = {}
        for x = 1, sx do
            grid[y][x] = tetram.back
        end
    end

    return grid
end

function ui_d()
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(font)
    love.graphics.print('Любит Тетрамино', 
                        _block_size/2, _block_size/2, 0, scale, scale)
    love.graphics.print('Score: ' .. string.format('%08d', score), 
                        _block_size/2, _block_size, 0, scale, scale)
    love.graphics.print('Level: ' .. string.format('%02d', level), 
                        _block_size/2, _block_size*1.5, 0, scale, scale)
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
                if game_grid[n][m] ~= tetram.back then
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


function move_p(x, y)
    if valid_pos(pid, pr, px + x, py + y) then
        px = px + x
        py = py + y
    end
end


function hit()
    bake_p(pid, pr, px, py)
    next_p()
end

function bake_p(id, r, x, y)
    local shape = tetram.shape[id][r]
    for j, l in ipairs(shape) do
        for i, c in ipairs(l) do
            if c ~= tetram.empty then
                m = i + x - 1
                n = j + y - 1
                local invalid =  m < 1 or n < 1 or  m > max_x or n > max_y
                if not invalid then 
                    game_grid[n][m] = c
                end
            end
        end
    end
end


function clear_lines(grid_map)
    local n_fell = 0
    if grid_map or false then else return n_fell end
    for y, l in ipairs(grid_map) do
        if n_line(l) == #l then
            n_fell = n_fell + 1
            for x, k in ipairs(l) do
                grid_map[y][x] = tetram.back
            end
        end
    end

    return n_fell
end


function fall_lines(grid_map)
    local final_pos = {}
    next_line = #grid_map
    for l = #grid_map, 1, -1 do
        if n_line(grid_map[l]) > 0 then
            final_pos[next_line] = l
            next_line = next_line - 1
        end
    end

    for i = #grid_map, next_line + 1, -1 do
        copy_v(grid_map[i], grid_map[final_pos[i]])
    end
    for i = next_line, 1, -1 do
        zero_v(grid_map[i])
    end
end


function copy_v(a, b)
    for i, v in pairs(b) do
        a[i] = v
    end
end


function zero_v(a)
    for i, v in pairs(a) do
        a[i] = tetram.back
    end
end


function n_line(line)
    local total = 0
    for _, i in pairs(line) do
        if i ~= tetram.back then
            total = total + 1
        end
    end

    return total
end


function d_grid(grid_map)
    if grid_map or false then else return end
    for y, l in ipairs(grid_map) do
        for x, k in ipairs(l) do
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


function d_fx()
end


function d_piece(id, rot, px, py, colour)
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


function set_scale(new_scale)
    if new_scale <= 0 then new_scale = 1 end
    if new_scale > _max_scale then new_scale = _max_scale end
    scale = new_scale
    set_sizes()
end


function set_sizes()
    _block_size = _base_block_size * scale
    _border = 1 * scale
    love.window.setMode((_grid_size[1] + 2) * _block_size,
                        (_grid_size[2] + 1 + _header_size) * _block_size)
end


function add_score(n_lines)
    local s_scale = 4
    score = score + (((n_lines * (n_lines + 1)) / 2) * (level + s_scale))
    level = math.floor((score)^0.6/10) + 1
    step = _base_step * (1/(level + 4)) * 6
end

