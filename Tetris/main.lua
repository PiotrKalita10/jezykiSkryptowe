lume = require "lume"

counter = 0
game_over = false
function love.load()
    love.window.setMode(400, 600)
    soundRotate = love.audio.newSource("rotate.wav", "static")
    soundRowClear = love.audio.newSource("clear.wav", "static")
    musicTetris = love.audio.newSource("music.mp3", "static")
    musicTetris:setVolume(0.4)
    musicTetris:play()
    block_size = 30
    grid_width = 10
    grid_height = 20
    grid = {}
    initGrid()

    shapes = {
        {
            { 0, 0, 0, 0 },
            { 0, 1, 1, 0 },
            { 0, 1, 1, 0 },
            { 0, 0, 0, 0 }
        },
        {
            { 0, 0, 0, 0 },
            { 0, 0, 0, 0 },
            { 1, 1, 1, 1 },
            { 0, 0, 0, 0 }
        },
        {
            { 0, 0, 0, 0 },
            { 0, 0, 1, 0 },
            { 1, 1, 1, 0 },
            { 0, 0, 0, 0 }
        },
        {
            { 0, 0, 0, 0 },
            { 0, 0, 1, 1 },
            { 0, 1, 1, 0 },
            { 0, 0, 0, 0 }
        },
        {
            { 0, 0, 0, 0 },
            { 1, 1, 0, 0 },
            { 0, 1, 1, 0 },
            { 0, 0, 0, 0 }
        },
        {
            { 0, 0, 0, 0 },
            { 0, 0, 1, 0 },
            { 0, 1, 1, 1 },
            { 0, 0, 0, 0 }
        }
    }

    piece = shapes[math.random(#shapes)]
    pieceX = 4
    pieceY = -1
    timer = 0

end

function initGrid()
    for y = 1, grid_height do
        grid[y] = {}
        for x = 1, grid_width do
            grid[y][x] = 0
        end
    end
end

function love.update(dt)
    timer = timer + dt
    if timer >= 0.5 then
        pieceY = pieceY + 1
        if not checkCollision() then
            pieceY = pieceY - 1
            if pieceY == -1 then
                game_over = true
            end
            for y = 1, #piece do
                for x = 1, #piece[y] do
                    local gridX = pieceX + x
                    local gridY = pieceY + y
                    if piece[y][x] == 1 and gridY > 0 then
                        grid[gridY][gridX] = piece[y][x]

                    end
                end
            end

            clearLine = true
            for y = grid_height, 1, -1 do
                local full = true
                for x = 1, grid_width do
                    if grid[y][x] == 0 then
                        full = false
                        break
                    end
                end
                if full then
                    for clearY = y, 2, -1 do
                        for clearX = 1, grid_width do
                            grid[clearY][clearX] = grid[clearY - 1][clearX]
                        end
                    end
                    for clearX = 1, grid_width do
                        grid[1][clearX] = 0
                    end

                    y = y + 1
                    soundRowClear:play()
                    soundRowClear:setVolume(1.5)
                    counter = counter + 1
                end
            end
            if not game_over then
                piece = shapes[math.random(#shapes)]
                pieceX = 4
                pieceY = -1
            end
        end
        timer = 0
    end
    if love.keyboard.isDown("down") then
        pieceY = pieceY + 1
        if not checkCollision() then
            pieceY = pieceY - 1
        end
    end
end

function love.keypressed(key)
    if key == "up" then
        soundRotate:play()
        soundRotate:setVolume(1.5)
        local rotatedPiece = {}
        for x = 1, #piece[1] do
            rotatedPiece[x] = {}
            for y = 1, #piece do
                rotatedPiece[x][y] = piece[#piece - y + 1][x]
            end
        end
        local originalPiece = piece
        piece = rotatedPiece
        if not checkCollision() then
            piece = originalPiece
        end
    elseif key == "left" and checkCollision() and pieceX >= 0 then
        pieceX = pieceX - 1

    elseif key == "right" and checkCollision() and pieceX <= grid_width - 4 and pieceX <= grid_width - 3 then
        pieceX = pieceX + 1
    elseif key == "s" then
        saveGame()
    elseif key == "l" then
        loadGame()


    end
end
function checkCollision()
    for y = 1, #piece do
        for x = 1, #piece[y] do
            if piece[y][x] == 1 then
                local gridX = pieceX + x
                local gridY = pieceY + y
                if gridX < 1 or gridX > grid_width or gridY > grid_height or (gridY > 0 and grid[gridY][gridX] == 1) then
                    return false
                end
            end
        end
    end
    return true
end

function saveGame()
    local saveData = {}
    saveData.grid = grid
    saveData.piece = piece
    saveData.pieceX = pieceX
    saveData.pieceY = pieceY
    saveData.timer = timer
    serialized = lume.serialize(saveData)
    love.filesystem.write("savedata.txt", serialized)
end

function loadGame()
    local saveData = lume.deserialize(love.filesystem.read("savedata.txt"))
    grid = saveData.grid
    piece = saveData.piece
    pieceX = saveData.pieceX
    pieceY = saveData.pieceY
    timer = saveData.timer
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    for y = 1, grid_height do
        for x = 1, grid_width do
            if grid[y][x] == 1 then
                love.graphics.rectangle("fill", (x - 1) * block_size, (y - 1) * block_size, block_size, block_size)
            end
            love.graphics.rectangle("line", (x - 1) * block_size, (y - 1) * block_size, block_size, block_size)
        end
    end
    love.graphics.setColor(0, 1, 0)
    for y = 1, #piece do
        for x = 1, #piece[y] do
            if piece[y][x] == 1 then
                love.graphics.rectangle("fill", (pieceX + x - 1) * block_size, (pieceY + y - 1) * block_size, block_size, block_size)
            end
        end
    end
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.print("TETRIS", 310, 50)
    love.graphics.setFont(love.graphics.newFont(15))
    love.graphics.print("Points: ", 310, 100)
    love.graphics.print(counter, 380, 100)
    if game_over then
        soundRowClear:stop()
        soundRotate:stop()
        musicTetris:stop()
        love.graphics.setFont(love.graphics.newFont(40))
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("GAME OVER", 50, 300)
    end
end
