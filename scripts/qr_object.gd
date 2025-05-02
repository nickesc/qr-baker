extends QRCodeRect

# QR Object Definitions

signal qr_set(qr_options: Dictionary)

@export_category("Properties")
@export var save_to_history: bool = true

@export_category("Default QR Options")
@export var DEFAULT_DATA: String = ""
@export var DEFAULT_ERROR_CORRECTION: QRCode.ErrorCorrection = QRCode.ErrorCorrection.MEDIUM
@export var DEFAULT_LIGHT_MODULE_COLOR: Color = Color("#FFFFFF", 0.0)
@export var DEFAULT_DARK_MODULE_COLOR: Color = Color("#000000", 1.0)
@export var DEFAULT_AUTO_MODULE_PIXEL_SIZE: bool = false
@export var DEFAULT_MODULE_PIXEL_SIZE: int = 10
@export var DEFAULT_QUIET_ZONE_SIZE: int = 4

@export_group("Hidden Defaults")
@export var _HIDDEN_DEFAULT_MODE: QRCode.Mode = QRCode.Mode.BYTE
@export var _HIDDEN_DEFAULT_USE_ECI: bool = true
@export var _HIDDEN_DEFAULT_ECI_VALUE: int = 26
@export var _HIDDEN_DEFAULT_AUTO_VERSION: bool = true
@export var _HIDDEN_DEFAULT_AUTO_MASK_PATTERN: bool = true

# Object

func _ready() -> void:
    reset_qr_to_default()
    print(get_data())
    pass
    
func qr_options(
        data_option: String = DEFAULT_DATA,
        error_correction_option: int = DEFAULT_ERROR_CORRECTION,
        light_module_color_option: Color = DEFAULT_LIGHT_MODULE_COLOR,
        dark_module_color_option: Color = DEFAULT_DARK_MODULE_COLOR,
        auto_module_px_size_option: bool = DEFAULT_AUTO_MODULE_PIXEL_SIZE,
        module_px_size_option: int = DEFAULT_MODULE_PIXEL_SIZE,
        quiet_zone_size_option: int = DEFAULT_QUIET_ZONE_SIZE ) -> Dictionary:
    return {
        "data": data_option,
        "error_correction": error_correction_option,
        "light_module_color": light_module_color_option,
        "dark_module_color": dark_module_color_option,
        "auto_module_px_size": auto_module_px_size_option,
        "module_px_size": module_px_size_option,
        "quiet_zone_size": quiet_zone_size_option
    }

func get_qr_options() -> Dictionary:
        return qr_options(
            get_data(), 
            get_error_correction() as QRCode.ErrorCorrection, 
            light_module_color, 
            dark_module_color, 
            auto_module_px_size, 
            int(module_px_size), 
            int(quiet_zone_size)
        )

func set_qr_options(options: Dictionary) -> Dictionary:
    set_data(options.data)
    set_error_correction(options.error_correction)
    set_light_module_color(Color(options.light_module_color))
    set_dark_module_color(Color(options.dark_module_color))
    set_auto_module_px_size(options.auto_module_px_size)
    if not options.auto_module_px_size:
        set_module_px_size(options.module_px_size)
    set_quiet_zone_size(options.quiet_zone_size)
    
    qr_set.emit(options)
        
    return options

func update_default_qr_options(options: Dictionary) -> Dictionary:
    DEFAULT_ERROR_CORRECTION = options.error_correction
    DEFAULT_LIGHT_MODULE_COLOR = options.light_module_color
    DEFAULT_DARK_MODULE_COLOR = options.dark_module_color
    DEFAULT_AUTO_MODULE_PIXEL_SIZE = options.auto_module_px_size
    DEFAULT_MODULE_PIXEL_SIZE = options.module_px_size
    DEFAULT_QUIET_ZONE_SIZE = options.quiet_zone_size
    
    return options

func _hidden_defaults():
    set_mode(_HIDDEN_DEFAULT_MODE)
    set_use_eci(_HIDDEN_DEFAULT_USE_ECI)
    set_eci_value(_HIDDEN_DEFAULT_ECI_VALUE)
    set_auto_version(_HIDDEN_DEFAULT_AUTO_VERSION)
    set_auto_mask_pattern(_HIDDEN_DEFAULT_AUTO_MASK_PATTERN)


func reset_qr_to_default() -> void:
    set_qr_options(qr_options())
    _hidden_defaults()
    
    qr_set.emit(get_qr_options())
