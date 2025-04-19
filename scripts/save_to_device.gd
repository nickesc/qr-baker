extends Button

signal ios_save(share: Share)
signal android_save(share: ShareAndroid)
signal web_save

@onready var save_dialogue = $SaveDialog

var share_android: ShareAndroid
var share_ios: Share

const mobile_button_height = 150
const mobile_button_text = "Export Image"

func _ready() -> void:
    match OS.get_name():
        "Android":
            share_android = ShareAndroid.new()
            add_child(share_android)
            text = mobile_button_text
            custom_minimum_size.y = mobile_button_height
        "iOS":
            share_ios = Share.new()
            share_ios.set_name("ShareiOS")
            add_child(share_ios)
            text = mobile_button_text
            custom_minimum_size.y = mobile_button_height
        "Web":
            text = "Download Image"
            
func _on_pressed() -> void:    
    match OS.get_name():
        "Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
            save_dialogue.visible = true
        "Android":
            android_save.emit(share_android)
        "iOS":
            ios_save.emit(share_ios)
        "Web":
            web_save.emit()
