extends Node

const QRCode = preload("res://addons/qr_code/qr_code.gd")

signal qr_saved(exit_code: int)

@export var qr: QRCodeRect

# Image Saver Definitions

@onready var save_dialog: FileDialog = $SaveDialog

var share_ios: Share

enum ExitCodes {
    DRY_RUN = -1,
    INCORRECT_SAVE_METHOD = -2,
    UNSUPPORTED_OS = -3,
    FAILED_TO_SAVE = 4
}

@export_category("Export Options")
@export var DEFAULT_MOBILE_FILENAME: String = "qr-code.png"
@export var DEFAULT_WEB_FILENAME: String = "qr-code.png"

# Image Saver

func _ready() -> void:
    match OS.get_name():
        "Android":
            OS.request_permissions()
        "iOS":
            share_ios = Share.new()
            add_child(share_ios)
        _:
            pass

func _on_save_pressed():
    save_dialog.start_save()

func _on_image_path_selected(filename: String, directory: String) -> void:
    save_qr_to_directory(filename, directory)
    
func _on_ios_share() -> void:
    var img: Image = qr.generate_qr_image()
    img.save_png("user://"+DEFAULT_MOBILE_FILENAME)
    
    var title: String = "QR Code"
    var subject: String = qr.data.left(20)
    var content: String = "QR Code"
    
    share_ios.share_image(OS.get_user_data_dir()+"/"+DEFAULT_MOBILE_FILENAME, title, subject, content)

func _on_web_download() -> void:
    var img: Image = qr.generate_qr_image()
    var buffer: PackedByteArray = img.save_png_to_buffer()
    JavaScriptBridge.download_buffer(buffer,DEFAULT_WEB_FILENAME, "image/png")
    
func save_qr_to_directory(filename: String, directory: String) -> void:
    var img: Image = qr.generate_qr_image()
    img.save_png("user://"+filename)
    
    var exit_code: int
    match OS.get_name():
        "Windows":
            exit_code = save_to_windows(filename, directory, true, false)
        "macOS":
            exit_code = save_to_unix(filename, directory, true, false)
        "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
            exit_code = save_to_unix(filename, directory, true, false)
        "Android":
            exit_code = save_to_unix(filename, directory, true, false)
        "iOS", "Web":
            exit_code = ExitCodes.INCORRECT_SAVE_METHOD
        _:
            exit_code = ExitCodes.UNSUPPORTED_OS
    
    qr_saved.emit(exit_code)

func save_to_unix(filename: String, target_dir: String, debug: bool=false, dry: bool=false) -> int:
    #var home_path: String = OS.get_environment("HOME")
    var user_data_path: String = OS.get_user_data_dir()+"/"+filename
    
    var command: String = "cp"
    
    return execute_copy(command, user_data_path, target_dir, debug, dry)

func save_to_windows(filename: String, target_dir: String, debug: bool=false, dry: bool=false) -> int:
    #var home_path: String = (OS.get_environment("USERPROFILE")).replace("/","\\")
    var user_data_path: String = (OS.get_user_data_dir()+"/"+filename).replace("/","\\")
    var destination_path: String = target_dir.replace("/","\\")
    
    var cmd: String = "CMD.exe"
    var dest: String = "/C"
    var program: String = "copy"
    
    var command: String = '%s "%s" "%s"' % [program, user_data_path, destination_path]
    
    return execute_copy(cmd, dest, command, debug, dry)

func execute_copy(command: String, source_file: String, target_dir: String, debug: bool = true, dry: bool = false) -> int:
    var exit_code: int
    var output: Array = []
    
    if not dry:
        exit_code = OS.execute(command, [source_file, target_dir], output, true)
    else:
        exit_code = ExitCodes.DRY_RUN
    
    if debug:
        print('["%s", ["%s","%s"]]' % [command, source_file, target_dir])
        #print("[\""+command+"\", [\""+source_file+"\", \""+target_dir+"\"]]")
        if not dry:
            print(exit_code, "\n", output)
    
    return exit_code
