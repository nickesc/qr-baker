extends PanelContainer

var panel_style_box: StyleBox = preload("res://themes/panel_stylebox.tres")
var mobile_style_box: StyleBox = preload("res://themes/mobile_stylebox.tres")

var ui_theme: Theme = preload("res://themes/ui_theme.tres")

@export_category("Button Scale")

@export var button_scale: float = 2
@export var spinbox_scale: float = 2
@export var spinbox_arrow_scale: float = 4
@export var text_edit_scale: float = 2
@export var label_scale: float = 2
@export var icon_button_scale: float = 2
@export var save_button_scale: float = 1.5

@export_group("Components")

@export var buttons: Array[Button]
@export var save_buttons: Array[Button]
@export var spinboxes: Array[SpinBox]
@export var text_edits: Array[TextEdit]
@export var labels: Array[Label]
@export var icon_buttons: Array[Button]


func _ready() -> void:
    match OS.get_name():
        "Android", "iOS":
            add_theme_stylebox_override("panel", mobile_style_box)
            update_theme_for_mobile()
        _:
            add_theme_stylebox_override("panel", panel_style_box)
            
            

func scale_minimum_size(node: Control, scale_x: float, scale_y: float):
    var new_button_size: Vector2 = node.get_custom_minimum_size() * Vector2(scale_x, scale_y)
    node.set_custom_minimum_size(new_button_size)

func scale_input_font(node: Control, font_scale: float, item_name: StringName = "font_size"):
    var new_font_size: float = node.get_theme_font_size(item_name) * font_scale
    node.add_theme_font_size_override(item_name, int(new_font_size))

func scale_spinbox_arrows(node: SpinBox, arrow_scale: float):
    var new_width: float = node.get_theme_constant("buttons_width") * arrow_scale
    node.add_theme_constant_override("buttons_width", int(new_width))

func update_theme_for_mobile():
    for item in buttons:
        scale_input_font(item, button_scale)
        scale_minimum_size(item, 1, button_scale)
    for item in spinboxes:
        scale_input_font(item.get_line_edit(), spinbox_scale)
        scale_minimum_size(item, 1, spinbox_scale)
        scale_spinbox_arrows(item, spinbox_arrow_scale)
    for item in text_edits:
        scale_input_font(item, text_edit_scale)
        scale_minimum_size(item, 1, text_edit_scale)
    for item in labels:
        scale_input_font(item, label_scale)
    for item in save_buttons:
        scale_input_font(item, button_scale)
        scale_minimum_size(item, 1, save_button_scale)
    for item in icon_buttons:
        scale_minimum_size(item, icon_button_scale, icon_button_scale)


func scale_item_font(font_scale: float, theme_type: StringName, item_name: StringName = "font_size"):
    var temp_font_size = ui_theme.get_font_size(item_name, theme_type)
    ui_theme.set_font_size(item_name, theme_type, temp_font_size*font_scale)
