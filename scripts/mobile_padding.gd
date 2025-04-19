extends PanelContainer

var panel_style_box: StyleBox = preload("res://themes/panelStyleBox.tres")
var mobile_style_box: StyleBox = preload("res://themes/mobileStyleBox.tres")

func _ready() -> void:
    match OS.get_name():
        "Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
            self.add_theme_stylebox_override("panel", panel_style_box)
        "Android", "iOS", "Web":
            self.add_theme_stylebox_override("panel", mobile_style_box)
