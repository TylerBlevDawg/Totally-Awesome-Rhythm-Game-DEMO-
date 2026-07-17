
local testLevel = {}
local gameModule = require("lua/gameModule")
gameModule.hitTable.times = {2000, 3000, 4000, 5000, 10000, 9999999}
gameModule.hitTable.keys = {C.FIRST_KEY, C.SECOND_KEY, "both", C.FIRST_KEY, "both"}
gameModule:setHitTable(gameModule.hitTable.times, gameModule.hitTable.keys)

local lastKeyHit = "null"
local test = love.physics.newWorld(0, 0)
local font = love.graphics.getFont()
local text
local text1
local text2
local text3
local text4
local text5

PlayButton = {}
PlayButton.body = love.physics.newBody(test, 1920/3, 100, "static")
PlayButton.shape = love.physics.newRectangleShape(1920/6, 50, 1920/3, 100)
PlayButton.fixture = love.physics.newFixture(PlayButton.body, PlayButton.shape)

function love.keypressed(key)
    if key == C.FIRST_KEY then
        gameModule:checkHit(key)
        lastKeyHit = key
    end
end

function testLevel:update(dt)
    gameModule:update(dt)
    text = love.graphics.newText(font, "hitState: " .. gameModule.hitState)
    text1 = love.graphics.newText(font, "gameTime: " .. gameModule.time)
    text2 = love.graphics.newText(font, "expectedHits: " .. gameModule.supHits)
    text3 = love.graphics.newText(font, "playerHits: " .. gameModule.playerHits)
    text4 = love.graphics.newText(font, "Next hit frame: " .. gameModule.hitTable.times[gameModule.supHits + 1] + gameModule.offset)
    text5 = love.graphics.newText(font, "playerMisses: " .. gameModule.playerMisses)
    if gameModule.time >= 15000 then
        gameModule:pauseGame()
    end
end

function testLevel.draw()
    love.graphics.draw(text, 10, 10)
    love.graphics.draw(text1, 10, 50)
    love.graphics.draw(text4, 10, 90)
    love.graphics.draw(text2, 10, 130)
    love.graphics.draw(text5, 10, 170)
    love.graphics.draw(text3, 10, 210)

    if gameModule.hitState == gameModule.hitStateEnum.perfect then
        love.graphics.rectangle("fill", PlayButton.body:getX(), 100, 1920/3, 100)
    elseif gameModule.hitState == gameModule.hitStateEnum.good then
        love.graphics.rectangle("fill", PlayButton.body:getX(), 300, 1920/3, 100)
    else
        love.graphics.rectangle("fill", PlayButton.body:getX(), 500, 1920/3, 100)
    end
end

return testLevel