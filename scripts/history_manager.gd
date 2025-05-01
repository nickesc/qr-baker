extends Node

var history: Dictionary

var session_history: Dictionary = {"history":[]}

func _on_qr_saved(_exit_code: int, qr: QRCodeRect) -> void:
    if qr.save_to_history:
        write_entry_to_history(qr.get_qr_options())
        #load_history()
        #print(history)

func load_history() -> void:
    history = session_history

func clear_history()-> void:
    session_history = {"history":[]}
    load_history()
    
func write_entry_to_history(entry: Dictionary) -> Dictionary:
    session_history.history.push_front(entry)
    return entry
