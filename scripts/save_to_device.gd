extends Button

signal ios_share
signal android_save
signal web_download
signal desktop_save

const mobile_button_height: int = 150

const desktop_button_text: String = "Save Image"
const ios_button_text: String = "Export Image"
const android_button_text: String = "Save Image"
const web_button_text: String = "Download Image"

func _ready() -> void:
    match OS.get_name():
        "Android":
            set_text(android_button_text)
            custom_minimum_size.y = mobile_button_height
        "iOS":
            set_text(ios_button_text)
            custom_minimum_size.y = mobile_button_height
        "Web":
            set_text(web_button_text)
        _:
            set_text(desktop_button_text)
            
func _on_pressed() -> void:    
    match OS.get_name():
        "Android":
            android_save.emit()
        "iOS":
            ios_share.emit()
        "Web":
            web_download.emit()
        _:
            desktop_save.emit()
