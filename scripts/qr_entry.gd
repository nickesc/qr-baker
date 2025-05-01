extends MarginContainer

signal save_entry_qr(qr: QRCodeRect)

@onready var qr: QRCodeRect = $EntryPanel/EntryContents/CodePanel/AspectRatioContainer/QR

#var reset: bool = false

#func _process(delta: float) -> void:
    #if not reset:
    #    reset = true
    #    qr.reset_qr_to_default()

func _ready() -> void:
    qr.reset_qr_to_default()
    #qr.call_deferred("reset_qr_to_default")
    #pass

func _on_save_pressed() -> void:
    save_entry_qr.emit(qr)
