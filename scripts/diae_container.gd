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
	refresh_tabs()

func _on_child_closed():
	refresh_tabs()

func toggle_tab_bar():
	var current = get_container_for_index($layout_container.current_tab)
	$layout_container/tabbed.tabs_visible = current.get_child_count() >= 2

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
	refresh_tabs()

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
	open_artefact(path)

func _on_open_artefact_received(path):
	print("Opening artefact at: {0}".format([path]))
	open_artefact(path)

func _on_editor_name_changed():
	refresh_tabs()

func refresh_tabs():
	refresh_tab_titles()
	toggle_tab_bar()

func refresh_tab_titles():
	var index = $layout_container.current_tab
	if index == 0:
		var tab_container: TabContainer = get_container_for_index(index)
		var children = tab_container.get_children()
		for i in range(len(children)):
			var child = children[i]
			var title = child.get_title()
			tab_container.set_tab_title(i, title)

func open_artefact(path):
	var editor = load("res://scenes/split_text_editor.tscn").instance()
	add_container(editor)
	editor.connect("open_artefact", self, "_on_open_artefact_received")
	editor.connect("name_changed", self, "_on_editor_name_changed")
	editor.set_artefact(path)
