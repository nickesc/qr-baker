extends VBoxContainer

@export_category("Components")
@export var menu: Control

func _on_back_pressed():
    if menu:
        menu.swap_app_screen(menu.qr_generator)

func _on_history_pressed() -> void:
    if menu:
        menu.swap_app_screen(menu.history_screen)

func _on_batch_pressed() -> void:
    if menu:
        menu.swap_app_screen(menu.batch_screen)

func _on_options_pressed() -> void:
    if menu:
        menu.swap_app_screen(menu.options_screen)

func _on_help_pressed() -> void:
    if menu:
        menu.swap_app_screen(menu.help_screen)


func _on_favorites_pressed() -> void:
    if menu:
        menu.swap_app_screen(menu.favorites_screen)
