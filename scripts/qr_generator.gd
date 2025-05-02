extends VBoxContainer

const QRCode = preload("res://addons/qr_code/qr_code.gd")

@onready var qr: QRCodeRect = $QRContainer/AspectRatioContainer/QR

# Generator Definitions

signal qr_generated(qr_options: Dictionary)
signal save_qr(qr: QRCodeRect)

@onready var data_field: TextEdit = $Properties/DataContainer/Data
@onready var error_correction_option: OptionButton = $Properties/Options/ErrorCorrection
@onready var light_modules_picker: ColorPickerButton = $Properties/Options/LightModuleColor
@onready var dark_modules_picker: ColorPickerButton = $Properties/Options/DarkModuleColor
@onready var auto_module_px_size_checkbox: CheckBox = $Properties/Options/AutoModulePxSize
@onready var module_px_size_spinner: SpinBox = $Properties/Options/ModulePxSize
@onready var quiet_zone_size_spinner: SpinBox = $Properties/Options/QuietZoneSize

# Built-in

func _ready() -> void:
    _on_reset_pressed()

# Generator

func _on_auto_module_px_size_toggled(toggled_on: bool) -> void:
    module_px_size_spinner.editable = not toggled_on

func _on_save_to_device_pressed() -> void:
    save_qr.emit(qr)

func _on_reset_pressed() -> void:
    qr.reset_qr_to_default()
    
    data_field.set_text(qr.DEFAULT_DATA)
    error_correction_option.select(error_correction_option.get_item_index(qr.DEFAULT_ERROR_CORRECTION))
    light_modules_picker.set_pick_color(qr.DEFAULT_LIGHT_MODULE_COLOR) 
    dark_modules_picker.set_pick_color(qr.DEFAULT_DARK_MODULE_COLOR)
    auto_module_px_size_checkbox.set_pressed(qr.DEFAULT_AUTO_MODULE_PIXEL_SIZE)
    module_px_size_spinner.set_value(qr.DEFAULT_MODULE_PIXEL_SIZE)
    quiet_zone_size_spinner.set_value(qr.DEFAULT_QUIET_ZONE_SIZE)

func _on_generate_pressed() -> void:
    var new_qr_options: Dictionary = get_current_qr_options()
    qr.set_qr_options(new_qr_options)
    qr_generated.emit(new_qr_options)

func get_current_qr_options() -> Dictionary:
    return qr.qr_options(
            data_field.get_text(), 
            error_correction_option.get_selected_id() as QRCode.ErrorCorrection, 
            light_modules_picker.get_pick_color(), 
            dark_modules_picker.get_pick_color(), 
            auto_module_px_size_checkbox.is_pressed(), 
            int(module_px_size_spinner.get_value()), 
            int(quiet_zone_size_spinner.get_value())
        )
