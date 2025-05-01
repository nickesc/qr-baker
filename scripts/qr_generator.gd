extends VBoxContainer

const QRCode = preload("res://addons/qr_code/qr_code.gd")

@onready var qr: QRCodeRect = $QRContainer/AspectRatioContainer/QR

# Generator Definitions

signal qr_generated(qr_options: Dictionary)
signal save_qr(qr: QRCodeRect)
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

func _on_save_to_device_pressed() -> void:
    save_qr.emit(qr)

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
    
    qr_generated.emit(options)
    
    return options

func update_default_qr_options(options: Dictionary) -> Dictionary:
    DEFAULT_ERROR_CORRECTION = options.error_correction
    DEFAULT_LIGHT_MODULE_COLOR = options.light_module_color
    DEFAULT_DARK_MODULE_COLOR = options.dark_module_color
    DEFAULT_AUTO_MODULE_PIXEL_SIZE = options.auto_module_px_size
    DEFAULT_MODULE_PIXEL_SIZE = options.module_px_size
    DEFAULT_QUIET_ZONE_SIZE = options.quiet_zone_size
    
    return options
