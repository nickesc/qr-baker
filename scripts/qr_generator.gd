extends VBoxContainer
const QRCode = preload("res://addons/qr_code/qr_code.gd")

signal qr_generated

@onready var data: TextEdit = $Properties/DataContainer/Data
@onready var errorCorrection: OptionButton = $Properties/Options/ErrorCorrection
@onready var lightModules: ColorPickerButton = $Properties/Options/LightModuleColor
@onready var darkModules: ColorPickerButton = $Properties/Options/DarkModuleColor
@onready var autoModulePxSize: CheckBox = $Properties/Options/AutoModulePxSize
@onready var modulePxSize: SpinBox = $Properties/Options/ModulePxSize
@onready var quietZoneSize: SpinBox = $Properties/Options/QuietZoneSize

@onready var generate: Button = $Submit/Generate
@onready var qr: QRCodeRect = $QRContainer/AspectRatioContainer/QR

func _on_auto_module_px_size_toggled(toggled_on: bool) -> void:
    modulePxSize.editable = not toggled_on

func get_qr_data() -> Variant:
    var qr_object = {}
    
    qr_object.data = data.text
    if qr_object.data == "":
        qr_object.data = "Data"
    qr_object.error_correction = errorCorrection.get_selected_id() as QRCode.ErrorCorrection
    qr_object.light_module_color = lightModules.color
    qr_object.dark_module_color = darkModules.color
    qr_object.auto_module_px_size = autoModulePxSize.is_pressed()
    qr_object.module_px_size = modulePxSize.value
    qr_object.quiet_zone_size = quietZoneSize.value
    
    return qr_object

func _on_generate_pressed() -> void:
    var qr_object = get_qr_data()
    
    qr.set_data(qr_object.data)
    qr.set_error_correction(qr_object.error_correction)
    qr.set_light_module_color(qr_object.light_module_color)
    qr.set_dark_module_color(qr_object.dark_module_color)
    qr.set_auto_module_px_size(qr_object.auto_module_px_size)
    if not qr_object.auto_module_px_size:
        qr.set_module_px_size(qr_object.module_px_size)
    qr.set_quiet_zone_size(qr_object.quiet_zone_size)
    qr_generated.emit(data.text)

func _on_save_pressed() -> void:
    var img: Image = qr.generate_qr_image()
    save_png_to_downloads(img, "qr_text_save.png")
    
func save_png_to_downloads(file: Image,filename: String):
    file.save_png("user://"+filename)
    
    match OS.get_name():
        "Windows":
            save_to_windows(file, filename, true, false)
        "macOS":
            save_to_unix(file, filename, true, false)
        "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
            save_to_unix(file, filename, true, false)
        "Android":
            save_to_unix(file, filename, true, true)
        "iOS":
            save_to_ios(file, filename, true, true)
        "Web":
            save_to_web(file, filename, true, true)
    
    var command = "cp"

func execute_copy(command: String, target_path: String, destination_path: String, debug: bool = true, dry: bool = false) -> int:
    var exit_code: int
    var output = []
    
    if not dry:
        exit_code = OS.execute(command, [target_path, destination_path], output, true)
    else:
        if debug:
            print(command+" \""+target_path+"\" \""+destination_path+"\"")
        exit_code = -1
    
    if debug:
        print(target_path, " ", destination_path)
        if not dry:
            print(exit_code, "\n", output)
    
    return exit_code

func save_to_web(file, filename, debug: bool=false, dry: bool=false) -> int:
    return -1

func save_to_ios(file, filename, debug: bool=false, dry: bool=false) -> int:
    return -1

func save_to_windows(file, filename, debug: bool=false, dry: bool=false) -> int:
    var home_path = (OS.get_environment("USERPROFILE")).replace("/","\\")
    var target_path = (OS.get_user_data_dir()+"/"+filename).replace("/","\\")
    var destination_path = (home_path+"/Downloads/").replace("/","\\")
    
    var cmd = "CMD.exe"
    var dest = "/C"
    var command = "copy"
    
    return execute_copy(cmd, dest, command+" \""+target_path+"\" \""+destination_path+"\"", debug, dry)

func save_to_unix(file, filename, debug: bool=false, dry: bool=false) -> int:
    var home_path = OS.get_environment("HOME")
    var target_path = OS.get_user_data_dir()+"/"+filename
    var destination_path = home_path+"/Downloads/"
    
    var command = "cp"
    
    return execute_copy(command, target_path, destination_path, debug, dry)
    
