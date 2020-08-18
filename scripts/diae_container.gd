extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$buttons/layout.add_item("Tabbed")
	$buttons/layout.add_item("Vertical")
	$buttons/layout.add_item("Horizontal")

func add_container(child):
	var current = get_container_for_index($layout_container.current_tab)
	child.connect("tree_exited", self, "_on_child_closed")
	current.add_child(child)
	toggle_tab_bar()

func _on_child_closed():
	toggle_tab_bar()

func toggle_tab_bar():
	var current = get_container_for_index($layout_container.current_tab)
	$layout_container/tabbed.tabs_visible = current.get_child_count() > 1

func _on_layout_item_selected(new_index):
	var old_index = $layout_container.current_tab
	var old = get_container_for_index(old_index)
	var new = get_container_for_index(new_index)
	$layout_container.current_tab = new_index
	var children = old.get_children()
	for child in children:
		old.remove_child(child)
		new.add_child(child)
		if old_index == 0:
			child.show()

func get_container_for_index(index):
	match index:
		0: return $layout_container/tabbed
		1: return $layout_container/vertical
		2: return $layout_container/horizontal

func _on_close_pressed():
	if get_parent() != get_node("/root/app"):
		queue_free()
	else:
		get_tree().quit()

func _on_add_container_pressed():
	var container = load("res://scenes/diae_container.tscn").instance()
	add_container(container)

func _on_open_pressed():
	$file_dialog.popup_centered_ratio()

func _on_file_dialog_file_selected(path):
	var editor = load("res://scenes/split_text_editor.tscn").instance()
	add_container(editor)
	editor.set_artefact(path)
	
