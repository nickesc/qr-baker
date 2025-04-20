extends HBoxContainer

var click_pos: Vector2 = Vector2.ZERO
var moving: bool = false

func _ready() -> void:
    match OS.get_name():
        "Android", "iOS", "Web":
            set_visible(false)
        _:
            set_visible(true)

func moveWindow():
    var new_pos: Vector2 = get_global_mouse_position() - click_pos
    DisplayServer.window_set_position(DisplayServer.window_get_position() + Vector2i(new_pos))

func _process(_delta):
    if moving:
        moveWindow()

func _on_close_pressed() -> void:
    get_tree().quit()
    
func _on_minimize_pressed() -> void:
    print("minimize")
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)

func _on_move_down() -> void:
    print("moving")
    click_pos = get_local_mouse_position() + Vector2(30,30)
    moving = true

func _on_move_up():
    print("stopped")
    moving=false
