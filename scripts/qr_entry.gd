extends MarginContainer

signal save_entry_qr(qr: QRCodeRect)
signal edit_entry(qr_options: Dictionary)
signal delete_entry(id: String)

@onready var qr: QRCodeRect = $EntryPanel/EntryContents/CodePanel/AspectRatioContainer/QR
@onready var data_label: Label = $EntryPanel/EntryContents/EntryData/QRCodeData
@onready var datetime_label: Label = $EntryPanel/EntryContents/EntryData/GeneratedDatetime

#var reset: bool = false

#func _process(delta: float) -> void:
    #if not reset:
    #    reset = true
    #    qr.reset_qr_to_default()

func _ready() -> void:
    qr.reset_qr_to_default()
    #qr.call_deferred("reset_qr_to_default")
    #pass

func set_datetime_label(string: String):
    datetime_label.set_text(string)

func set_data_label(string: String):
    data_label.set_text(string)

func set_qr(qr_options: Dictionary) -> void:
    qr.set_qr_options(qr_options)

func connect_save_signal(callback: Callable):
    save_entry_qr.connect(callback.bind(qr))
    

func _on_save_pressed() -> void:
    save_entry_qr.emit(qr)

func _on_edit_pressed() -> void:
    edit_entry.emit(qr.get_qr_options())

func _on_delete_pressed() -> void:
    delete_entry.emit("")
