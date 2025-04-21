extends PanelContainer

var panel_style_box: StyleBox = preload("res://themes/panel_stylebox.tres")
var mobile_style_box: StyleBox = preload("res://themes/mobile_stylebox.tres")

func _ready() -> void:
    match OS.get_name():
        "Android", "iOS", "Web":
            add_theme_stylebox_override("panel", mobile_style_box)
        _:
            add_theme_stylebox_override("panel", panel_style_box)
