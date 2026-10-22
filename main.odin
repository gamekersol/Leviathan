package main
import "scenes"
import "Textures"
import rl "vendor:raylib"


main :: proc (){
    WindowInit()
    rl.InitAudioDevice();
    Textures.UploadAllTextures()

    music : rl.Music = rl.LoadMusicStream("Audio/noise_1.mp3");
    music.looping = true;
    pitch := 1.0

    rl.PlayMusicStream(music);

    scenes.loadScene(&scenes.diveScene)
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()

        // rl.BeginMode2D(cam)
        // defer rl.EndMode2D()

        rl.UpdateMusicStream(music);

        scenes.curentScene.Update(rl.GetFrameTime())
    }

    rl.CloseWindow()
}

WindowInit :: proc(){
    rl.InitWindow(1280, 720, "The Eighth Day of the Earth")
    rl.SetTargetFPS(140)
    rl.SetWindowState({
        .FULLSCREEN_MODE,
        .WINDOW_UNDECORATED,
        .WINDOW_UNFOCUSED,
    })
}