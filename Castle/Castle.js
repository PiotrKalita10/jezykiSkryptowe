function createWall(p1: Position, length: number, height: number, stoneType: any) {
    for (let i = 0; i <= height; i++) {
        shapes.line(stoneType, positions.add(p1, pos(0, i, 0)), positions.add(p1, pos(length, i, 0)))
        shapes.line(stoneType, positions.add(p1, pos(0, i, 0)), positions.add(p1, pos(0, i, length)))
        shapes.line(stoneType, positions.add(p1, pos(length, i, 0)), positions.add(p1, pos(length, i, length)))
        shapes.line(stoneType, positions.add(p1, pos(0, i, length)), positions.add(p1, pos(length, i, length)))
    }
}

function createBricks(p1: Position, length: number, height: number) {
    for (let i = 0; i <= length; i += 2) {
        blocks.place(STONE_BRICKS, positions.add(p1, pos(i, height, 0)))
        blocks.place(STONE_BRICKS, positions.add(p1, pos(0, height, i)))

        blocks.place(STONE_BRICKS, positions.add(p1, pos((length - i), height, length)))
        blocks.place(STONE_BRICKS, positions.add(p1, pos(length, height, (length - i))))
    }
}

function createCube(p1: Position, p2: Position, maxLenght: number, height: number, stoneType: any) {
    for (let i = 0; i < height; i++) {
        for (let j = 0; j <= maxLenght; j++) {
            shapes.line(stoneType, positions.add(p1, pos(0, i, j)), positions.add(p2, pos(0, i, j)))
        }
    }
}

function createWalls() {
    createWall(world(1, -60, 1), 98, 11, STONE_BRICKS)
    createWall(world(0, -60, 0), 100, 11, STONE_BRICKS)
    createWall(world(-1, -60, -1), 102, 11, STONE_BRICKS)
    createWall(world(1, -49, 1), 98, 0, BIRCH_WOOD_SLAB)
    createWall(world(0, -49, 0), 100, 0, BIRCH_WOOD_SLAB)
    createWall(world(-1, -49, -1), 102, 0, BIRCH_WOOD_SLAB)
    createWall(world(-2, -60, -2), 104, 12, STONE_BRICKS)
    createWall(world(-3, -60, -3), 106, 12, STONE_BRICKS)

    createCube(world(-10, -60, -10), world(10, -60, -10), 20, 22, STONE_BRICKS)
    createCube(world(90, -60, -10), world(110, -60, -10), 20, 22, STONE_BRICKS)
    createCube(world(-10, -60, 90), world(10, -60, 90), 20, 22, STONE_BRICKS)
    createCube(world(90, -60, 90), world(110, -60, 90), 20, 22, STONE_BRICKS)
    createCube(world(-10, -38, -10), world(10, -38, -10), 20, 1, BIRCH_WOOD_SLAB)
    createCube(world(90, -38, -10), world(110, -38, -10), 20, 1, BIRCH_WOOD_SLAB)
    createCube(world(-10, -38, 90), world(10, -38, 90), 20, 1, BIRCH_WOOD_SLAB)
    createCube(world(90, -38, 90), world(110, -38, 90), 20, 1, BIRCH_WOOD_SLAB)
    for (let i = 0; i < 2; i++) {
        createBricks(world(-3, -60, -3), 106, 13 + i)
        createBricks(world(-10, -60, -10), 20, 22 + i)
        createBricks(world(90, -60, -10), 20, 22 + i)
        createBricks(world(-10, -60, 90), 20, 22 + i)
        createBricks(world(90, -60, 90), 20, 22 + i)
    }
}

function createCastle() {
    createCube(world(25, -60, 25), world(75, -60, 25), 50, 20, STONE_BRICKS)
    createCube(world(25, -40, 25), world(75, -40, 25), 50, 1, OAK_WOOD_SLAB)
    createCube(world(37.5, -40, 37.5), world(62.5, -40, 37.5), 25, 15, LIGHT_GRAY_WOOL)
    for (let i = 0; i < 2; i++) {
        createBricks(world(25, -60, 25), 50, 20 + i)
    }
    createBricks(world(37.5, -40, 37.5), 25, 15)
}

function createGate() {
    createCube(world(95, -60, 25), world(105, -60, 25), 10, 15, STONE_BRICKS)
    createCube(world(95, -60, 65), world(105, -60, 65), 10, 15, STONE_BRICKS)
    createCube(world(95, -45, 25), world(105, -45, 25), 10, 1, BIRCH_WOOD_SLAB)
    createCube(world(95, -45, 65), world(105, -45, 65), 10, 1, BIRCH_WOOD_SLAB)
    createCube(world(95, -60, 45), world(105, -60, 45), 10, 8, AIR)
    for (let i = 0; i < 2; i++) {
        createBricks(world(95, -60, 25), 10, 15 + i)
        createBricks(world(95, -60, 65), 10, 15 + i)
    }
    for (let i = -60; i < -52; i++) {
        shapes.line(DARK_OAK_FENCE, world(103, i, 45), world(103, i, 55))
    }
}

function createWindow(p1: Position, p2: Position, length: number, height: number, depth: number, blockType: any) {
    for (let j = 0; j < length; j++) {
        for (let i = 0; i <= height; i++) {
            for (let k = 0; k <= depth; k++) {
                shapes.line(AIR, positions.add(p1, pos(-k, i, j)), positions.add(p1, pos(-k, i, j)))

            }
            shapes.line(blockType, positions.add(p1, pos(0, i, j)), positions.add(p1, pos(0, i, j)))
        }
    }
}

function createWater(p1: Position, length: number) {
    for (let i = 0; i < 20; i++) {
        createWall(positions.add(p1, pos(-i, 0, -i)), length, 1, WATER)
        length += 2
    }
}

createWater(world(-20, -62, -20), 140)

createWalls()
createCastle()
createGate()

createWindow(world(63, -35, 44), world(63, -35, 49), 4, 6, 8, GLASS)
createWindow(world(63, -35, 55), world(63, -35, 61), 4, 6, 8, GLASS)
createWindow(world(75, -50, 34), world(75, -50, 39), 4, 6, 8, GLASS)
createWindow(world(75, -50, 61), world(75, -50, 67), 4, 6, 8, GLASS)
createWindow(world(75, -60, 47), world(75, -60, 54), 7, 8, 1, CHERRY_WOOD)
createCube(world(119, -60, 45), world(140, -60, 45), 10, 1, DARK_OAK_WOOD_SLAB)
createCube(world(0, -60, 0), world(100, -60, 0), 100, 1, SANDSTONE)
createCube(world(75, -60, 45), world(119, -60, 45), 10, 1, COBBLESTONE)
shapes.line(DARK_OAK_FENCE, world(119, -59, 45), world(140, -59, 45))
shapes.line(DARK_OAK_FENCE, world(119, -59, 55), world(140, -59, 55))



