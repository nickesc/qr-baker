extends Control

var click_pos = Vector2.ZERO
var global_click_pos = Vector2.ZERO
var window_pos
var window_size
var distance_to_edge_vertical
var distance_to_edge_horizontal

var following_vertical = false
var following_horizontal = false
var following_diagonal = false

@onready var horizontal_resize = $HorizontalResize
@onready var vertical_resize = $VerticalResize


func handle_input(event, following) -> bool:
    if event is InputEventMouseButton:
        if event.get_button_index() == 1:
            click_pos = get_local_mouse_position()
            window_pos = DisplayServer.window_get_position()
            window_size = DisplayServer.window_get_size()
            
            return not following
    return following

func _on_vertical_resize(event: InputEvent) -> void:
    following_vertical = handle_input(event, following_vertical)

func _on_horizontal_resize(event: InputEvent) -> void:
    following_horizontal = handle_input(event, following_horizontal)
    
func _on_diagonal_resize(event: InputEvent) -> void:
    following_diagonal = handle_input(event, following_diagonal)


func _ready() -> void:
    match OS.get_name():
        "Windows", "macOS":
            visible = true
        "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD", "Android", "iOS", "Web":
            visible = false
    
    distance_to_edge_vertical = DisplayServer.window_get_size().y - vertical_resize.global_position.y
    distance_to_edge_horizontal = horizontal_resize.global_position.x - DisplayServer.window_get_size().x

func _process(delta: float) -> void:
    var x_size = DisplayServer.window_get_size().x
    var y_size = DisplayServer.window_get_size().y
    if following_vertical or following_diagonal:
        y_size = get_global_mouse_position().y
    if following_horizontal or following_diagonal:
        x_size = get_global_mouse_position().x
    if following_vertical or following_horizontal or following_diagonal:
        DisplayServer.window_set_size(Vector2(max(x_size, 513), max(y_size, 900)))
    
