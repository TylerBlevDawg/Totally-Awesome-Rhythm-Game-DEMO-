--[[ 
    Rules for creating levels:
    1. Do not let gameModule.time exceed hitTable.times, put a large number at the end of the table
       such that the game will continue after it is officially done handle game end by force pausing after
       the music ends
    2. 
--]]

-- Uses dt + inputted list of good beats to register when a hit is good, medium, or bad
gameModule = {}

gameModule.state = 1 -- state will contain 1 of 2 integer corresponding ("active" 1, "pause" 0) it will start active
gameModule.hitState = 0 -- hitState will contain 1 of 3 integers corresponding ("miss" 0, "good" 1, "perfect" 2)
gameModule.hitStateEnum = { miss = 0, good = 1, perfect = 2 }
gameModule.hitTable = {}
gameModule.hitTable.times = {} -- Table time will contain, in milliseconds, a table of beats to hit in order
gameModule.hitTable.keys = {} -- Table keyType will contain the key to hit at the specific time
gameModule.offset = C.OFFSET
gameModule.time = 0
gameModule.supHits = 0
gameModule.playerHits = 0
gameModule.playerPerfHits = 0
gameModule.playerMisses = 0
gameModule.multiHitProtection = false

-- cool divider between vars and functions

function gameModule:setHitTable(timeTable, keyTable)
    self.hitTable.times = timeTable
    self.hitTable.keys = keyTable
end

function gameModule:pauseGame()
    self.state = 0
end

function gameModule:activateGame()
    self.state = 1
end

-- Will return 1 of 3 strings ("perfect", "good", "miss")
-- perfect: within 50 ms // good: within 90 ms // bad: anything past 70ms
function gameModule:checkHit(key)
    if self.hitState == self.hitStateEnum.good and key == self.hitTable.keys[self.supHits + 1] and not gameModule.multiHitProtection then
        self.playerHits = self.playerHits + 1
        gameModule.multiHitProtection = true
    elseif self.hitState == self.hitStateEnum.perfect and key == self.hitTable.keys[self.supHits + 1] and not gameModule.multiHitProtection then
        self.playerHits = self.playerHits + 1
        self.playerPerfHits = self.playerPerfHits + 1
        gameModule.multiHitProtection = true
    else
        self.playerMisses = self.playerMisses + 1
        return gameModule.hitStateEnum.miss
    end
    return self.hitState
end

function gameModule:checkHitDebug()
    return gameModule.time
end

function gameModule:update(dt)
    if self.state == 1 then
        self.time = self.time + (dt * 100)
    end

    if (self.hitTable.times[self.supHits + 1] + self.offset) - self.time <= C.PERF_THRESH then
        self.hitState = self.hitStateEnum.perfect
    elseif (self.hitTable.times[self.supHits + 1] + self.offset) - self.time <= C.GOOD_THRESH then
        self.hitState = self.hitStateEnum.good
    else
        self.hitState = self.hitStateEnum.miss
    end

    if self.hitTable.times[self.supHits + 1] + self.offset + C.GOOD_THRESH <= self.time then
        self.supHits = self.supHits + 1
        gameModule.multiHitProtection = false
    end
end

-- Debug fun

function gameModule.keypressed(key)
    if key == "space" then
        gameModule.supHits = gameModule.supHits + 1
    elseif key == "p" then
        gameModule:pauseGame()
    elseif key == "o" then
        gameModule:activateGame()
    end
end

-- nothing goes below here >:|

return gameModule
