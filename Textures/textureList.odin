package textures
import rl "vendor:raylib"
import "core:fmt"
import "../Shared"

textures : map[string]rl.Texture

LoadTexture :: proc (str : string) -> rl.Texture2D {return rl.LoadTexture(fmt.ctprintf("Textures/%s.png", str))}
// Get :: proc (str : string) -> rl.Texture2D {return textures[str]}

Anchor :: enum {
    Top_Left, Top, Top_Right,
    Left, Center, Right,
    Bottom_Left, Bottom, Bottom_Right,
}

anchor_factor := [Anchor][2]f32{
    .Top_Left     = {0,   0},
    .Top          = {0.5, 0},
    .Top_Right    = {1,   0},
    .Left         = {0,   0.5},
    .Center       = {0.5, 0.5},
    .Right        = {1,   0.5},
    .Bottom_Left  = {0,   1},
    .Bottom       = {0.5, 1},
    .Bottom_Right = {1,   1},
}

Draw :: proc (name : string, posX, posY : i32, anchor := Anchor.Top_Left){
    posX := posX + i32(anchor_factor[anchor].x * Shared.wSize.x)
    posY := posY + i32(anchor_factor[anchor].y * Shared.wSize.y)
    rl.DrawTexture(textures[name], posX , posY, rl.WHITE)
}

UploadAllTextures :: proc (){
    if textures == nil do textures = make (map[string]rl.Texture)

    textures["bg"] = LoadTexture("bg")
    textures["screen"] = LoadTexture("ScreenArea")
    textures["mainPanel"] = LoadTexture("Panel")
}

