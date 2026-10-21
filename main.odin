package main
import "scenes"
import rl "vendor:raylib"

main :: proc (){
    windowInit()

    scenes.loadScene(&scenes.diveScene)
    for !rl.WindowShouldClose() do scenes.curentScene.Update(rl.GetFrameTime())
    
    rl.CloseWindow()
}

windowInit :: proc(){
    rl.InitWindow(1280, 720, "The Eighth Day of the Earth")
    rl.SetTargetFPS(140)
    //rl.SetWindowFocused()
    rl.SetWindowState({
        .FULLSCREEN_MODE,
        .WINDOW_UNDECORATED,
    })
}