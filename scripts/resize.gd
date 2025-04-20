extends Control

@export_category("Resize Options")
@export var max_x_size: int = 513
@export var max_y_size: int = 900

var click_pos: Vector2 = Vector2.ZERO
var global_click_pos: Vector2 = Vector2.ZERO
var window_pos: Vector2
var window_size: Vector2
var distance_to_edge_vertical: float
var distance_to_edge_horizontal: float

var following_vertical: bool = false
var following_horizontal: bool = false
var following_diagonal: bool = false

@onready var horizontal_resize: Control = $HorizontalResize
@onready var vertical_resize: Control = $VerticalResize


func _ready() -> void:
    match OS.get_name():
        "Windows", "macOS":
            distance_to_edge_vertical = DisplayServer.window_get_size().y - vertical_resize.global_position.y
            distance_to_edge_horizontal = horizontal_resize.global_position.x - DisplayServer.window_get_size().x
            set_visible(true)
        _:
            set_visible(false)

func _process(_delta: float) -> void:
    var x_size = DisplayServer.window_get_size().x
    var y_size = DisplayServer.window_get_size().y
    
    if following_vertical or following_diagonal:
        y_size = get_global_mouse_position().y
    if following_horizontal or following_diagonal:
        x_size = get_global_mouse_position().x
    if following_vertical or following_horizontal or following_diagonal:
        DisplayServer.window_set_size(Vector2(max(x_size, max_x_size), max(y_size, max_y_size)))

func _on_vertical_resize(event: InputEvent) -> void:
    following_vertical = handle_input(event, following_vertical)

func _on_horizontal_resize(event: InputEvent) -> void:
    following_horizontal = handle_input(event, following_horizontal)
    
func _on_diagonal_resize(event: InputEvent) -> void:
    following_diagonal = handle_input(event, following_diagonal)

func handle_input(event, following) -> bool:
    if event is InputEventMouseButton:
        if event.get_button_index() == 1:
            click_pos = get_local_mouse_position()
            window_pos = DisplayServer.window_get_position()
            window_size = DisplayServer.window_get_size()
            
            return not following
    return following
    
