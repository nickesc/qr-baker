extends VBoxContainer



@export_category("Components")
@export var menu: Control
@export var history_manager: Node
@export var qr_saver: Node
#@export_file('*.tscn') var qr_entry_scene: String

@onready var qr_entry_scene: PackedScene = preload("res://objects/qr_entry.tscn")
@onready var history_list_vbox: VBoxContainer = $ScrollContainer/HistoryList

var loading_list: bool = false
var curr_loading_index: int = 0

func _process(_delta: float) -> void:
    if loading_list:
        if curr_loading_index<history_manager.history.history.size():
            var load_entry = history_manager.history.history[curr_loading_index]
            set_up_entry(load_entry)
            curr_loading_index+=1
        else:
            loading_list = false
            curr_loading_index=0

func _on_back_pressed():
    if menu:
        menu.swap_app_screen(menu.more_screen)

func clear_history_list_vbox():
    var previous_history = history_list_vbox.get_children()
    for child in previous_history:
        child.free()

func _on_clear_pressed():
    loading_list = false
    curr_loading_index=0
    clear_history_list_vbox()
    history_manager.clear_history()

func set_up_entry(entry: Dictionary) -> Node:
    print(entry)
    var qr_entry_node = qr_entry_scene.instantiate()
    history_list_vbox.add_child(qr_entry_node)
    qr_entry_node.set_qr(entry)
    if entry.data == "":
        qr_entry_node.set_data_label("<NO DATA>")
    else:
        qr_entry_node.set_data_label(entry.data)
        
    qr_entry_node.set_datetime_label("00:00")
    qr_entry_node.save_entry_qr.connect(qr_saver._on_save_entry)
    
    return qr_entry_node

func _on_visibility_changed() -> void:
    
    if not visible:
        clear_history_list_vbox()
    else:
        history_manager.load_history()
        loading_list = true
        
