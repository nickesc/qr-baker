extends Node

@export var history_filename: String = "user://history.json"

var history: Dictionary = {"history":[]}

var session_history: Dictionary = {"history":[]}

func _ready() -> void:
    load_history()

func _on_qr_saved(_exit_code: int, qr: QRCodeRect) -> void:
    if qr.save_to_history:
        write_entry_to_history(qr.get_qr_options())

func load_history() -> void:
    var history_file = FileAccess.open(history_filename, FileAccess.READ)
    if history_file:
        var content = history_file.get_as_text()
        history = JSON.parse_string(content)
        history_file.close()
    else:
        print("no history file")

func save_history(content: Variant) -> void:
    var history_file = FileAccess.open(history_filename, FileAccess.WRITE)
    history_file.store_string(JSON.stringify(content))
    history_file.close()

func clear_history()-> void:
    var clear: Dictionary = {"history":[]}
    save_history(clear)
    load_history()
    
func write_entry_to_history(entry: Dictionary) -> Dictionary:
    if entry.light_module_color:
        entry.light_module_color = entry.light_module_color.to_html()
    if entry.dark_module_color or entry.dark_module_color == Color(0, 0, 0, 1):
        entry.dark_module_color = entry.dark_module_color.to_html()
    history.history.push_front(entry)
    save_history(history)
    return entry
