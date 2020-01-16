local tetramino = {}

tetramino.empty = ''

tetramino.ids = {'O', 'J', 'L', 'T', 'S', 'Z', 'I'}

local t1 = 0.9
local t0 = 0.1
local t12 = 0.5
tetramino.colour = {}
tetramino.colour.O = {t1, t1, t0}
tetramino.colour.J = {t0, t0, t1}
tetramino.colour.L = {t1, t2, t0}
tetramino.colour.T = {t1, t2, t2}
tetramino.colour.S = {t0, t1, t0}
tetramino.colour.Z = {t1, t0, t0}
tetramino.colour.I = {t0, t1, t1}
tetramino.colour[''] = nil
tetramino.colour[0] = {0.8, 0.8, 0.8}
tetramino.colour[1] = {0.2, 0.2, 0.2}

tetramino.shape = {}
tetramino.shape.O = {
    {{0,0,0,0},
     {0,1,1,0},
     {0,1,1,0},
     {0,0,0,0}}
}
tetramino.shape.J = {
    {{0,0,0,0},
     {0,0,1,0},
     {0,0,1,0},
     {0,1,1,0}},
    {{0,0,0,0},
     {1,0,0,0},
     {1,1,1,0},
     {0,0,0,0}},
    {{0,0,0,0},
     {0,1,1,0},
     {0,1,0,0},
     {0,1,0,0}},
    {{0,0,0,0},
     {0,1,1,1},
     {0,0,0,1},
     {0,0,0,0}}
 }
tetramino.shape.L = {
    {{0,0,0,0},
     {0,1,0,0},
     {0,1,0,0},
     {0,1,1,0}},
    {{0,0,0,0},
     {1,1,1,0},
     {1,0,0,0},
     {0,0,0,0}},
    {{0,0,0,0},
     {0,1,1,0},
     {0,0,1,0},
     {0,0,1,0}},
    {{0,0,0,0},
     {0,0,0,1},
     {0,1,1,1},
     {0,0,0,0}}
 }
tetramino.shape.T = {
    {{0,0,0,0},
     {0,1,0,0},
     {1,1,1,0},
     {0,0,0,0}},
    {{0,0,0,0},
     {0,1,0,0},
     {0,1,1,0},
     {0,1,0,0}},
    {{0,0,0,0},
     {0,0,0,0},
     {1,1,1,0},
     {0,1,0,0}},
    {{0,0,0,0},
     {0,0,1,0},
     {0,1,1,0},
     {0,0,1,0}},
}
tetramino.shape.S = {
    {{0,0,0,0},
     {0,1,1,0},
     {1,1,0,0},
     {0,0,0,0}},
    {{0,0,0,0},
     {0,1,0,0},
     {0,1,1,0},
     {0,0,1,0}},
}
tetramino.shape.Z = {
    {{0,0,0,0},
     {1,1,0,0},
     {0,1,1,0},
     {0,0,0,0}},
    {{0,0,0,0},
     {0,0,1,0},
     {0,1,1,0},
     {0,1,0,0}},
}
tetramino.shape.I = {
    {{0,1,0,0},
     {0,1,0,0},
     {0,1,0,0},
     {0,1,0,0}},
    {{0,0,0,0},
     {0,0,0,0},
     {1,1,1,1},
     {0,0,0,0}},
}
tetramino.shape[''] = {
    {{0,0,0,0},
     {0,0,0,0},
     {0,0,0,0},
     {0,0,0,0}}
 }

for s, t in pairs(tetramino.shape) do
    for r, l in ipairs(t) do
        for x, ss in ipairs(l) do
            for y, c in ipairs(ss) do
                if c == 1 then
                    tetramino.shape[s][r][x][y] = t
                else
                    tetramino.shape[s][r][x][y] = tetramino.empty
                end
            end
        end
    end
end

return tetramino
