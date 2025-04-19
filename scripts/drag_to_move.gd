extends ColorRect

var click_pos = Vector2.ZERO

func _ready():
    pass

func _process(_delta):
    if Input.is_action_just_pressed("click"):
        click_pos = get_local_mouse_position()
    if Input.is_action_pressed("click"):
        var new_pos = get_global_mouse_position() - click_pos
        DisplayServer.window_set_position(
            DisplayServer.window_get_position() +
            Vector2i(new_pos)
        )
