extends VBoxContainer

@export_category("Components")
@export var menu: Control

func _on_back_pressed():
    if menu:
        menu.swap_app_screen(menu.more_screen)
