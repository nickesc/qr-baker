extends HBoxContainer

var click_pos: Vector2 = Vector2.ZERO
var moving: bool = false

@onready var close: Button = $Close
@onready var minimize: Button = $Minimize
@onready var separator: Control = $Separator
@onready var header: Button = $Header
@onready var web_header: Button = $WebHeader
@onready var separator2: Control = $Separator2
@onready var help: Button = $Help

@export_category("Components")
@export var highest_content: HBoxContainer

@export_group("Screens")
@export var qr_generator: Control
@export var more_screen: Control
@export var help_screen: Control
@export var history_screen: Control
@export var batch_screen: Control
@export var options_screen: Control

#@onready var screens: Array[Control] = [qr_generator, help_screen, history_screen, batch_screen, options_screen]

#var screen_stack: Array[Control] = [qr_generator]

func _ready() -> void:
    match OS.get_name():
        "Android", "iOS":
            help.reparent(highest_content)
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
            
    swap_app_screen(qr_generator)

func swap_app_screen(target: Control = null):
    qr_generator.hide()
    more_screen.hide()
    help_screen.hide()
    
    history_screen.hide()
    batch_screen.hide()
    options_screen.hide()
    
    if target:
        target.show()

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
    
func _on_help_pressed() -> void:
    OS.shell_open("https://github.com/nickesc/qr-baker/blob/main/README.md")

func _on_more_pressed():
    if not more_screen.visible:
        swap_app_screen(more_screen)
    else:
        swap_app_screen(qr_generator)
    

func _on_move_down() -> void:
    print("moving")
    header.set_default_cursor_shape(Control.CURSOR_DRAG)
    click_pos = get_local_mouse_position() + Vector2(20,20)
    moving = true

func _on_move_up():
    print("stopped")
    header.set_default_cursor_shape(Control.CURSOR_POINTING_HAND)
    moving=false
