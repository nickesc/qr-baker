extends FileDialog

signal image_path_selected(filename: String, directory: String)

@export_category("File Dialogue Options")
@export var DEFAULT_FILENAME: String = "qr-code.png"

var latest_filename: String
var latest_dir: String

func _ready() -> void:
    latest_filename = DEFAULT_FILENAME
    set_visible(false)

func _on_file_selected(_path: String) -> void:
    set_latest_to_file()
    print("Save: ", "[" + latest_filename + ", " + latest_dir + "]")
    image_path_selected.emit(latest_filename, latest_dir)

func _on_close_dialog():
    set_latest_to_file()
    print("Close: ", "[" + latest_filename + ", " + latest_dir + "]")

func start_save():
    set_file_to_latest()
    set_visible(true)
    print("Open: ", "[" + latest_filename + ", " + latest_dir + "]")

func set_latest_to_file():
    if current_file:
        latest_filename = current_file
    latest_dir = current_dir

func set_file_to_latest():
    set_current_file(latest_filename)
    if latest_dir:
        set_current_dir(latest_dir)


    
