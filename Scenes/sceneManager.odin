package scenes

curentScene : ^Scene

Scene :: struct
{
    Init : proc(),
    Update : proc(delta_time : f32)
}

loadScene :: proc(scene : ^Scene)
{
    curentScene = scene
    curentScene.Init()
}