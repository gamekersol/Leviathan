package scenes
import tx "../Textures"
import "core:math/rand"
import rl "vendor:raylib"
import sh "../Shared"
import "core:fmt"

// CONSTANTS
MOVE_SPEED :: 80 // per second

// SOUNDS
noise2,arrowSound,specSound,switchSound1,switchSound2,switchSound3,switchSound4 : rl.Sound

// SCREEN VARS
Screen :: struct{
    pos : [2]f32,
    enabled : bool,
}
screens : [6]Screen
screenIndex := 2
move_input : [2]f32
maskBg : rl.RenderTexture

diveScene := Scene{
    Init = proc (){

        // SOUNDS
        noise2 = rl.LoadSound("Audio/noise_2.mp3")
        arrowSound = rl.LoadSound("Audio/Button_Arrow.ogg")
        specSound = rl.LoadSound("Audio/Button_Special.mp3")
        for &sc in screens do sc = {{rand.float32_range(200, 1700),rand.float32_range(200, 800)},true}
        rl.SetSoundPan(noise2, -0.5)

        maskBg = rl.LoadRenderTexture(i32(sh.wSize.x), i32(sh.wSize.y))
    },
    Update = proc (delta_time : f32){
        // DRAW
        {
            // LIGHTEN FOR BG
            rl.BeginTextureMode(maskBg)
            rl.ClearBackground(rl.BLACK)
            rl.BeginBlendMode(.ADDITIVE)
            for sc in screens do if sc.enabled do tx.Draw("screenMask", i32(sc.pos.x) - 180, -i32(sc.pos.y) + 700)
            rl.EndBlendMode()
            rl.EndTextureMode()

            // IMPORTANT
            tx.Draw("bg",0,0)

            // UNEDR MASK
            loc := rl.GetShaderLocation(tx.maskShader, "mask")
            rl.SetShaderValueTexture(tx.maskShader, loc, maskBg.texture)
            rl.BeginShaderMode(tx.maskShader)
            tx.Draw("frame0",0,0)
            rl.EndShaderMode()


            loc = rl.GetShaderLocation(tx.fiheyeShader, "resolution")
            rl.SetShaderValue(tx.fiheyeShader, loc, &sh.wSize, .VEC2)
            rl.BeginShaderMode(tx.fiheyeShader)
            for sc in screens do if sc.enabled do tx.Draw("screen", i32(sc.pos.x), i32(sc.pos.y))
            rl.EndShaderMode()
            tx.Draw("mainPanel", 300, 930) 
        }
        // INPUTS
        {
            // ARROWS
            index := -1
            if sh.CheckInputArea(.square, {717, 965}, 20) do index = 0
            if sh.CheckInputArea(.square, {709, 1015}, 20) do index = 1
            if sh.CheckInputArea(.square, {717 + 40, 990}, 20) do index = 2
            if sh.CheckInputArea(.square, {717 - 50, 990}, 20) do index = 3

            if index < 0|| rl.IsMouseButtonReleased(.LEFT) 
            {
                rl.StopSound(noise2)
                move_input = {0,0}
            }
            else if rl.IsMouseButtonPressed(.LEFT) {
                switch index {
                    case 0 :
                        // up
                        move_input = {0,-1}
                        rl.SetSoundPan(arrowSound, -0.4)
                        break
                    case 1 :
                        // down
                        move_input = {0,1}
                        rl.SetSoundPan(arrowSound, -0.4)
                        break
                    case 2 :
                        // left
                        move_input = {1,0}
                        rl.SetSoundPan(arrowSound, 0.4)
                        break
                    case 3 :
                        // right
                        move_input = {-1,0}
                        rl.SetSoundPan(arrowSound, 0.4)
                        break
                }

                rl.SetSoundPitch(noise2, rand.float32_range(0.9, 1.1))
                rl.SetSoundPitch(arrowSound, rand.float32_range(0.9, 1.1))
                rl.PlaySound(noise2)
                rl.PlaySound(arrowSound)
            }
            // SWITCH SC
            if sh.Debug && move_input.x != 0 do fmt.print(move_input)
            if rl.IsMouseButtonPressed(.LEFT) {
                if sh.CheckInputArea(.square, {1300, 1025}, 27) do screenIndex = 0
                if sh.CheckInputArea(.square, {1300 + 25 * 1, 1025 - 30}, 24) do screenIndex = 1

                if sh.CheckInputArea(.square, {1375, 1025}, 27) do screenIndex = 2
                if sh.CheckInputArea(.square, {1375 + 25 * 1, 1025 - 30}, 24) do screenIndex = 3

                if sh.CheckInputArea(.square, {1450, 1025}, 27) do screenIndex = 4
                if sh.CheckInputArea(.square, {1450 + 25 * 1, 1025 - 30}, 24) do screenIndex = 5
            }


            // CHANGE STATE OF SCREEN
            if rl.IsMouseButtonPressed(.LEFT) {
            if sh.CheckInputArea(.circle, {980, 1000}, 27) {
                screens[screenIndex].enabled = !screens[screenIndex].enabled
                rl.PlaySound(specSound)
            }
            // RIGHT BUTTON DOESNT WORK, IT BROKEN BY LORE (I FORGOT WHAT IT SHOULD DO)
            // ADD HOW MANY TIMES YOU PRESSED IT IN FINAL
            //if sh.CheckInputArea(.square, {985, 9080}, 27) do screenIndex = 0
            }
        }
        // CHANGES
        {
            sc_delta : [2]f32 = {MOVE_SPEED * delta_time * move_input.x,  MOVE_SPEED * delta_time * move_input.y}
            screens[screenIndex].pos = {screens[screenIndex].pos.x + sc_delta.x, screens[screenIndex].pos.y + sc_delta.y}
        }
    }
}