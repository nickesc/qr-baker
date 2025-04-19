extends FileDialog

@export var qr: QRCodeRect

signal image_path_selected(filename: String, directory: String)

func _ready() -> void:
    visible = false

func _on_file_selected(path: String) -> void:
    var filename: String = current_file
    var directory: String = current_dir
    
    image_path_selected.emit(filename, directory)
