function love.load()
    input = require('input')
    tetram = require('tetramino')
    px = 0
    py = 3
    pr = 1
    pid = ''
    nx = -2
    ny = 3
    nid = ''
    
    scale = 3
    _grid_size = {10, 22}
    _block_size = 25 * scale
    _border = 1 * scale
    _header_size = 2
    game_grid = setup_grid(_grid_size[1], _grid_size[2])

    back_c = {0.5, 0.5, 0.5}

    love.window.setMode((_grid_size[1] + 2) * _block_size,
                        (_grid_size[2] + 2 + _header_size) * _block_size)
    love.graphics.setBackgroundColor(0.95, 0.95, 0.95)
end


function love.update(ts)
    input.update(ts)
    if input.get_key('left') then move_piece(-1, 0) end
    if input.get_key('right') then move_piece(1, 0) end
    if input.get_key('up') then move_piece(0, -1) end
    if input.get_key('down') then move_piece(0, 1) end
    if input.get_key('a1') then next_p() end
end


function love.draw()
    --Drawing the background
    d_background() 
    --Drawing the game state
    d_grid(game_grid)
    --Drawing FX layer
    d_grid(fx)
    --Drawing active piece
    draw_piece(pid, pr, px, py)
    --Drawing next piece
    draw_piece(nid, 1, nx, ny)
end


function setup_grid(sx, sy)
    local grid = {}
    for x = 1, sx do
        grid[x] = {}
        for y = 1, sy do
            grid[x][y] = 0
        end
    end

    return grid
end


function next_p()
    local n = math.random(1, #tetram.ids)
    pid = nid
    nid = tetram.ids[n]
    print(nid, pid)
end


function move_piece(x, y)
    px = px + x
    py = py + y
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
                            ((_header_size + 1) * _block_size) - _border,
                            _grid_size[1]*_block_size + _border,
                            _grid_size[2]*_block_size + _border)
end


function d_square(x, y, c)
    if c or false then else return end
    y = y + _header_size
    love.graphics.setColor(c[1], c[2], c[3])
    love.graphics.rectangle('fill', 
                            x * _block_size, 
                            y * _block_size, 
                            _block_size - _border,
                            _block_size - _border)
end


function draw_piece(id, rot, px, py)
    local shape = tetram.shape[id]
    if shape or false then else return end
    shape = shape[rot]
    for x, l in ipairs(shape) do
        for y, c in ipairs(l) do
            d_square(px + x - 1, py + y - 1, tetram.colour[c])
        end
    end
end
