-- main.lua

local cube = {}
local angleX, angleY, angleZ = 0, 0, 0
local char = "-"
local color = {1, 1, 1}
local cameraZ = 300 -- Initial camera position along the Z axis
local minZoom, maxZoom = 100, 800 -- Zoom limits
local dragging = false
local lastMouseX, lastMouseY = 0, 0

love.window.setFullscreen(true)
isFullScreen = love.window.getFullscreen()

-- Initialize the cube with 8 vertices
function initCube(size)
    local s = size / 2
    return {
        {-s, -s, -s},
        { s, -s, -s},
        { s,  s, -s},
        {-s,  s, -s},
        {-s, -s,  s},
        { s, -s,  s},
        { s,  s,  s},
        {-s,  s,  s}
    }
end

-- Function to project 3D into 2D
function project3D(x, y, z, width, height, cameraZ)
    local factor = cameraZ / (z + cameraZ)
    local x2d = x * factor + width / 2
    local y2d = -y * factor + height / 2
    return x2d, y2d
end

-- Function to rotate points around the axes
function rotateX(x, y, z, angle)
    local rad = math.rad(angle)
    local cosa = math.cos(rad)
    local sina = math.sin(rad)
    return x, y * cosa - z * sina, y * sina + z * cosa
end

function rotateY(x, y, z, angle)
    local rad = math.rad(angle)
    local cosa = math.cos(rad)
    local sina = math.sin(rad)
    return x * cosa + z * sina, y, -x * sina + z * cosa
end

function rotateZ(x, y, z, angle)
    local rad = math.rad(angle)
    local cosa = math.cos(rad)
    local sina = math.sin(rad)
    return x * cosa - y * sina, x * sina + y * cosa, z
end

function interpolate3D(p1, p2, steps)
    local points = {}
    for i = 0, steps do
        local t = i / steps
        local x = p1[1] + (p2[1] - p1[1]) * t
        local y = p1[2] + (p2[2] - p1[2]) * t
        local z = p1[3] + (p2[3] - p1[3]) * t
        table.insert(points, {x, y, z})
    end
    return points
end

function love.load()
    cube = initCube(100)
end

function love.update(dt)
    if not dragging then
        angleX = angleX + 30 * dt
        angleY = angleY + 20 * dt
        angleZ = angleZ + 10 * dt
    end

    -- Update the color over time
    local time = love.timer.getTime()
    color[1] = (math.sin(time) + 1) / 2 -- Red variation
    color[2] = (math.sin(time + 2) + 1) / 2 -- Green variation
    color[3] = (math.sin(time + 4) + 1) / 2 -- Blue variation
end

function love.wheelmoved(x, y)
    if y > 0 then
        cameraZ = math.min(cameraZ * 1.5, maxZoom)
    elseif y < 0 then
        cameraZ = math.max(cameraZ / 1.5, minZoom)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        dragging = true
        lastMouseX, lastMouseY = x, y
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        dragging = false
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if dragging then
        angleY = angleY + dx * -0.5
        angleX = angleX + dy * -0.5
        lastMouseX, lastMouseY = x, y
    end
end

function love.keypressed(key)
    if key == 'r' then
        if love.window.getFullscreen() then
            love.window.setFullscreen(false)
        else
            love.window.setFullscreen(true)
        end
    end
end

function love.draw()

    love.graphics.print("Press 'R' key to toggle Full Screen", 10, 10, 0, 2, 2)
    love.graphics.print("Press 'Mouse Left Button' and drag to manually rotate the cube", 10, 50, 0, 2, 2)
    love.graphics.print("Scroll 'Mouse Wheel' to Increase or Decrease the cube's size", 10, 100, 0, 2, 2)

    local width, height = love.graphics.getDimensions()

    local projected = {}

    for i, vertex in ipairs(cube) do
        local x, y, z = vertex[1], vertex[2], vertex[3]

        -- Apply rotation
        x, y, z = rotateX(x, y, z, angleX)
        x, y, z = rotateY(x, y, z, angleY)
        x, y, z = rotateZ(x, y, z, angleZ)

        -- Project to 2D
        local x2d, y2d = project3D(x, y, z, width, height, cameraZ)
        table.insert(projected, {x2d, y2d})
    end

    -- Draw lines between the vertices
    local edges = {
        {1, 2}, {2, 3}, {3, 4}, {4, 1}, -- Back face
        {5, 6}, {6, 7}, {7, 8}, {8, 5}, -- Front face
        {1, 5}, {2, 6}, {3, 7}, {4, 8}  -- Connections between faces
    }

    -- Draw internal points of the cube faces
    local faces = {
        {1, 2, 6, 5},
        {2, 3, 7, 6},
        {3, 4, 8, 7},
        {4, 1, 5, 8},
        {1, 2, 3, 4},
        {5, 6, 7, 8}
    }

    local steps = 50 -- Number of steps for interpolation (higher value means more filled)

    love.graphics.setColor(color) -- Use the updated color

    for _, face in ipairs(faces) do
        local p1, p2, p3, p4 = face[1], face[2], face[3], face[4]
        for i = 0, steps do
            for j = 0, steps do
                local x1 = cube[p1][1] + (cube[p2][1] - cube[p1][1]) * i / steps
                local y1 = cube[p1][2] + (cube[p2][2] - cube[p1][2]) * i / steps
                local z1 = cube[p1][3] + (cube[p2][3] - cube[p1][3]) * i / steps

                local x2 = cube[p4][1] + (cube[p3][1] - cube[p4][1]) * i / steps
                local y2 = cube[p4][2] + (cube[p3][2] - cube[p4][2]) * i / steps
                local z2 = cube[p4][3] + (cube[p3][3] - cube[p4][3]) * i / steps

                local x = x1 + (x2 - x1) * j / steps
                local y = y1 + (y2 - y1) * j / steps
                local z = z1 + (z2 - z1) * j / steps

                x, y, z = rotateX(x, y, z, angleX)
                x, y, z = rotateY(x, y, z, angleY)
                x, y, z = rotateZ(x, y, z, angleZ)

                local x2d, y2d = project3D(x, y, z, width, height, cameraZ)
                love.graphics.print(char, x2d, y2d)
            end
        end
    end
end