extends HBoxContainer

var click_pos: Vector2 = Vector2.ZERO
var moving: bool = false

@onready var close: Button = $Close
@onready var minimize: Button = $Minimize
@onready var separator: Control = $Separator
@onready var header: Button = $Header
@onready var web_header: Button = $WebHeader


func _ready() -> void:
    match OS.get_name():
        "Android", "iOS":
            set_visible(false)
        "Web":
            close.set_visible(false)
            minimize.set_visible(false)
            separator.set_visible(false)
            header.set_visible(false)
            web_header.set_visible(true)
        "macOS":
            minimize.set_visible(false)
        _:
            pass

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
    header.set_default_cursor_shape(Control.CURSOR_DRAG)
    click_pos = get_local_mouse_position() + Vector2(20,20)
    moving = true

func _on_move_up():
    print("stopped")
    header.set_default_cursor_shape(Control.CURSOR_POINTING_HAND)
    moving=false
