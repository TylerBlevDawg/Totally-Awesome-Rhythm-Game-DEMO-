-- Settings here

local C = {
    FIRST_KEY = "j",
    SECOND_KEY = "k",
    OFFSET = 0,
    PERF_THRESH = 50,
    GOOD_THRESH = 90,
    DISPLAY_FPS = 1,
    VSYNC = 1,
}

love.window.setVSync(C.VSYNC)

return C