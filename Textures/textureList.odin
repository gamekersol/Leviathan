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

fiheyeShader : rl.Shader
maskShader : rl.Shader

UploadAllTextures :: proc (){
    if textures == nil do textures = make (map[string]rl.Texture)

    textures["bg"] = LoadTexture("bg")
    fiheyeShader = rl.LoadShader(nil, "Shaders/fiheye.fs")
    maskShader = rl.LoadShader(nil, "Shaders/mask.fs")
    // Get shader locations
    // int outlineSizeLoc = GetShaderLocation(shdrOutline, "outlineSize");
    // int outlineColorLoc = GetShaderLocation(shdrOutline, "outlineColor");
    // int textureSizeLoc = GetShaderLocation(shdrOutline, "textureSize");

    // // Set shader values (they can be changed later)
    // SetShaderValue(shdrOutline, outlineSizeLoc, &outlineSize, SHADER_UNIFORM_FLOAT);
    // SetShaderValue(shdrOutline, outlineColorLoc, outlineColor, SHADER_UNIFORM_VEC4);
    // SetShaderValue(shdrOutline, textureSizeLoc, textureSize, SHADER_UNIFORM_VEC2);

    //BeginShaderMode(shdrOutline);

    textures["screen"] = LoadTexture("ScreenArea")
    textures["mainPanel"] = LoadTexture("Panel")
    textures["screenMask"] = LoadTexture("screen_mask")
    for i in 0..<1 do textures[fmt.aprintf("frame%i",i)] = LoadTexture(fmt.aprintf("Frames/frame%i",i))
}

