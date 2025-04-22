extends VBoxContainer

const QRCode = preload("res://addons/qr_code/qr_code.gd")

@onready var qr: QRCodeRect = $QRContainer/AspectRatioContainer/QR


# Generator Definitions

signal qr_generated
signal qr_saved(exit_code: int)

@export_category("Default QR Options")
@export var DEFAULT_DATA: String = ""
@export var DEFAULT_ERROR_CORRECTION = QRCode.ErrorCorrection.MEDIUM
@export var DEFAULT_LIGHT_MODULE_COLOR: Color = Color("#FFFFFF", 0.0)
@export var DEFAULT_DARK_MODULE_COLOR: Color = Color("#000000", 1.0)
@export var DEFAULT_AUTO_MODULE_PIXEL_SIZE: bool = false
@export var DEFAULT_MODULE_PIXEL_SIZE: int = 10
@export var DEFAULT_QUIET_ZONE_SIZE: int = 4

@onready var data_field: TextEdit = $Properties/DataContainer/Data
@onready var error_correction_option: OptionButton = $Properties/Options/ErrorCorrection
@onready var light_modules_picker: ColorPickerButton = $Properties/Options/LightModuleColor
@onready var dark_modules_picker: ColorPickerButton = $Properties/Options/DarkModuleColor
@onready var auto_module_px_size_checkbox: CheckBox = $Properties/Options/AutoModulePxSize
@onready var module_px_size_spinner: SpinBox = $Properties/Options/ModulePxSize
@onready var quiet_zone_size_spinner: SpinBox = $Properties/Options/QuietZoneSize

@onready var generate: Button = $Submit/Generate


# Image Saver Definitions

enum ExitCodes {
    DRY_RUN = -1,
    INCORRECT_SAVE_METHOD = -2,
    UNSUPPORTED_OS = -3,
    FAILED_TO_SAVE = 4
}

@export_category("Export Options")
@export var DEFAULT_MOBILE_FILENAME: String = "qr-code.png"
@export var DEFAULT_WEB_FILENAME: String = "qr-code.png"

# Built-in

func _ready() -> void:
    _on_reset_pressed()


# Generator

func qr_options(
        data: String = DEFAULT_DATA,
        error_correction: int = DEFAULT_ERROR_CORRECTION,
        light_module_color: Color = DEFAULT_LIGHT_MODULE_COLOR,
        dark_module_color: Color = DEFAULT_DARK_MODULE_COLOR,
        auto_module_px_size: bool = DEFAULT_AUTO_MODULE_PIXEL_SIZE,
        module_px_size: int = DEFAULT_MODULE_PIXEL_SIZE,
        quiet_zone_size: int = DEFAULT_QUIET_ZONE_SIZE ) -> Dictionary:
    return {
        "data": data,
        "error_correction": error_correction,
        "light_module_color": light_module_color,
        "dark_module_color": dark_module_color,
        "auto_module_px_size": auto_module_px_size,
        "module_px_size": module_px_size,
        "quiet_zone_size": quiet_zone_size
    }

func _on_auto_module_px_size_toggled(toggled_on: bool) -> void:
    module_px_size_spinner.editable = not toggled_on

func _on_reset_pressed() -> void:
    data_field.set_text(DEFAULT_DATA)
    error_correction_option.select(error_correction_option.get_item_index(DEFAULT_ERROR_CORRECTION))
    light_modules_picker.set_pick_color(DEFAULT_LIGHT_MODULE_COLOR) 
    dark_modules_picker.set_pick_color(DEFAULT_DARK_MODULE_COLOR)
    auto_module_px_size_checkbox.set_pressed(DEFAULT_AUTO_MODULE_PIXEL_SIZE)
    module_px_size_spinner.set_value(DEFAULT_MODULE_PIXEL_SIZE)
    quiet_zone_size_spinner.set_value(DEFAULT_QUIET_ZONE_SIZE)
    
    set_qr_rect(qr_options())

func _on_generate_pressed() -> void:
    set_qr_rect(get_current_qr_options())

func get_current_qr_options() -> Dictionary:
    return qr_options(
            data_field.get_text(), 
            error_correction_option.get_selected_id() as QRCode.ErrorCorrection, 
            light_modules_picker.get_pick_color(), 
            dark_modules_picker.get_pick_color(), 
            auto_module_px_size_checkbox.is_pressed(), 
            int(module_px_size_spinner.get_value()), 
            int(quiet_zone_size_spinner.get_value())
        )

func set_qr_rect(options: Dictionary) -> Dictionary:
    qr.set_data(options.data)
    qr.set_error_correction(options.error_correction)
    qr.set_light_module_color(options.light_module_color)
    qr.set_dark_module_color(options.dark_module_color)
    qr.set_auto_module_px_size(options.auto_module_px_size)
    if not options.auto_module_px_size:
        qr.set_module_px_size(options.module_px_size)
    qr.set_quiet_zone_size(options.quiet_zone_size)
    
    qr_generated.emit(options.data)
    
    return options

func update_default_qr_options(options: Dictionary) -> Dictionary:
    DEFAULT_ERROR_CORRECTION = options.error_correction
    DEFAULT_LIGHT_MODULE_COLOR = options.light_module_color
    DEFAULT_DARK_MODULE_COLOR = options.dark_module_color
    DEFAULT_AUTO_MODULE_PIXEL_SIZE = options.auto_module_px_size
    DEFAULT_MODULE_PIXEL_SIZE = options.module_px_size
    DEFAULT_QUIET_ZONE_SIZE = options.quiet_zone_size
    
    return options


# Image Saver

func _on_image_path_selected(filename: String, directory: String) -> void:
    save_qr_to_directory(filename, directory)
    
#func _on_android_save() -> void:
    #var target_dir: String = OS.get_system_dir(OS.SystemDir.SYSTEM_DIR_DCIM)
    #save_qr_to_directory(DEFAULT_MOBILE_FILENAME, target_dir)
    
func _on_ios_share(share: Share) -> void:
    var img: Image = qr.generate_qr_image()
    img.save_png("user://"+DEFAULT_MOBILE_FILENAME)
    
    var title: String = "QR Code"
    var subject: String = qr.data.left(20)
    var content: String = "QR Code"
    
    share.share_image(OS.get_user_data_dir()+"/"+DEFAULT_MOBILE_FILENAME, title, subject, content)

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
