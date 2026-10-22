package shared
import rl "vendor:raylib"

area_type :: enum{
    circle,
    square,
}
CheckInputArea :: proc(type := area_type.square, pos : rl.Vector2, size : i32) -> bool{
    diff := pos - rl.GetMousePosition()
    diff.x = diff.x if diff.x>0 else -diff.x
    diff.y = diff.y if diff.y>0 else -diff.y
    result : bool
    switch type{
        case .square :
            result = diff.x < f32(size) && diff.y < f32(size)
            if Debug do rl.DrawRectangle(i32(pos.x) - size/2,i32(pos.y)- size/2,size*2,size*2,rl.ColorAlpha(rl.RED if result else rl.GREEN, 0.3))
        break
        case .circle : 
            result = rl.Vector2Length(diff) < f32(size)
        if Debug do rl.DrawCircle(i32(pos.x)- size/2,i32(pos.y)- size/2,f32(size),rl.ColorAlpha(rl.RED if result else rl.GREEN, 0.3))
        break
    }
    return result
}