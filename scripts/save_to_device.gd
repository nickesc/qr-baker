extends Button

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
