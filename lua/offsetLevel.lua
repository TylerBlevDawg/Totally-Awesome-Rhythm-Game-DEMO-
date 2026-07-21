--[[
    The idea of the offset level is that we will have a track that will have 4 beats
    After the 4 beats play, we'll set the time of the track and gametime to 0 so that it repeats with the same hitTable (We'll calculate this by checking that gametime + dt >= 4000 ms then resetting)
    We'll use the debug function that returns the gametime on hit and subtract the hitTabletime from the hit to find the offset
    We'll push that offset to a table and average it out to find the suggested offset, but we'll also provide a space both here and in settings to set the offset manually
--]]

local offsetLevel = {}
local gameModule = require("lua/gameModule")
local offsetTimes = {}
local avgOffset = 0
gameModule.hitTable.times = {0, 1000, 2000, 3000}
gameModule.hitTable.keys = {}
gameModule:setHitTable(gameModule.hitTable.times, gameModule.hitTable.keys)

local test = love.physics.newWorld(0, 0)

-- Code for visuals goes here

function love.keypressed(key)
    if key == C.FIRST_KEY then
        local hit = gameModule.time + gameModule.offset -- TODO!!!! FIGURE OUT HOW TO PROPERLY CALCULATE OFFSET
    end

    gameModule.keypressed(key)
end

function testLevel:update(dt)
    gameModule:update(dt)

    for i, v in ipairs(offsetTimes) do
      avgOffset = avgOffset + v
    end
    avgOffset = avgOffset / #offsetTimes
    gameModule.offset = avgOffset
  
    if gameModule.time >= 4000 then -- Reset with carryover time 
        gameModule.time = gameModule.time - 4000
        gameModule.supHits = 0
    end
end

function testLevel.draw()
    if gameModule.hitState == gameModule.hitStateEnum.perfect then
        love.graphics.rectangle("fill", PlayButton.body:getX(), 100, 1920/3, 100)
    elseif gameModule.hitState == gameModule.hitStateEnum.good then
        love.graphics.rectangle("fill", PlayButton.body:getX(), 300, 1920/3, 100)
    else
        love.graphics.rectangle("fill", PlayButton.body:getX(), 500, 1920/3, 100)
    end
end

return testLevel
