extends Container

var current_artefact: ArtefactMarkdown
var active = false

signal open_artefact(artefact_path)
signal name_changed

func _ready():
	$file_dialog.current_dir = Global.get_setting("library_path")

func get_title():
	var title = "Markdown Editor"
	if not current_artefact == null:
		title = Global.shorten_title(current_artefact.path)
	return title

func set_artefact(artefact_path: String):
	active = false
	if ArtefactManager.is_valid_artefact_of_type(artefact_path, ArtefactMarkdown) == OK:
		var prev_artefact = current_artefact
		current_artefact = ArtefactManager.load_artefact(artefact_path)
		assert(current_artefact is ArtefactMarkdown)
		if prev_artefact != null:
			prev_artefact.changed.disconnect(_on_artefact_changed)
		current_artefact.changed.connect(_on_artefact_changed)
		%markdown_label.set_artefact(artefact_path)
		%markdown_edit.text = current_artefact.text
		%markdown_edit.clear_undo_history()
		_on_text_edit_focus_exited()
		_on_text_edit_text_changed()
		active = true
		change_name()

func change_name():
	$buttons/title.set_text(get_title())
	emit_signal("name_changed")

func _on_text_edit_text_changed():
	if %markdown_edit.editable:
		current_artefact.text = %markdown_edit.text

func _on_artefact_changed():
	if not %markdown_edit.editable:
		%markdown_edit.text = current_artefact.text

func _on_text_edit_focus_exited():
	# TODO: don't end editing when focus is still in search panel! Only close when focus leaves scene.
	var ratio = %markdown_edit.get_v_scroll_bar().ratio
	%markdown_edit.editable = false
	%markdown_edit.hide()
	%markdown_label.show()
	%markdown_label.get_v_scroll_bar().ratio = ratio
	%markdown_label.grab_focus()
	current_artefact.render_content()
	current_artefact.store_content()

func _on_rich_text_label_gui_input(event: InputEvent):
	if not active:
		return
	var click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
	var doubleclick = click and event.is_double_click()
	if doubleclick:
		start_editing()
	if event.is_action_pressed("ui_find"):
		find()
	if event.is_action_pressed("ui_cancel") and $findpanel.visible:
		_on_find_close_pressed()

func find():
	if %markdown_edit.editable:
		print_debug("opening find panel in text editor")
	else:
		print_debug("opening find panel in markdown viewer")
	$findpanel.show()
	%findentry.grab_focus()

func get_approximate_line(pos: Vector2):
	var bar: VScrollBar = %markdown_label.get_v_scroll_bar()
	var ratio = bar.ratio
	var max_y = %markdown_label.get_content_height()
	var top_y = ratio * max_y
	var n_lines = %markdown_label.get_line_count()
	var v_lines = %markdown_label.get_visible_line_count()
	var top_line = ratio * n_lines
	var y = pos.y
	var clicked_y = top_y + y
	var rel_y = clamp(clicked_y / max_y, 0.0, 1.0)
	var clicked_line = min(rel_y * n_lines, n_lines)
	var debug_output = """Approximate vertical position:
	{0}px / {1}px = {2}
	Ratio {3}
	Top Y: {4}, Clicked Y: {5}, Max y : {6}
	Top line: {7}, Clicked line: {8}, Max line: {9}
	""".format([
				y, size.y, rel_y,
				ratio,
				top_y, clicked_y, max_y,
				top_line, clicked_line, n_lines
				])
	print_debug(debug_output)
	return ratio

func start_editing():
	%markdown_edit.editable = true
	%markdown_label.hide()
	%markdown_edit.show()
	%markdown_edit.grab_focus()
	%markdown_edit.get_v_scroll_bar().ratio = %markdown_label.get_v_scroll_bar().ratio

func _on_close_pressed():
	queue_free()

func _on_file_dialog_file_selected(path):
	set_artefact(path)

func _on_open_pressed():
	$file_dialog.popup_centered_ratio()

func _on_rich_text_label_meta_clicked(meta: String):
	var library_path = Global.get_setting("library_path")
	if meta.begins_with("#"):
		var artefact_name = meta
		if meta.get_extension() == "":
			artefact_name = "{0}.md".format([meta])
		artefact_name = artefact_name.trim_prefix("#") # removes `#`
		var path = library_path.path_join(artefact_name)
		emit_signal("open_artefact", path)
	elif meta.begins_with("user://"):
		emit_signal("open_artefact", meta)
	elif meta.begins_with("res://"):
		emit_signal("open_artefact", meta)
	elif meta.begins_with(library_path):
		emit_signal("open_artefact", meta)
	else:
		var path = meta
		if meta.is_relative_path():
			path = Util.normalize_path(library_path.path_join(meta))
			path = "file://".path_join(path)
			printerr("""Relative path handling is still wrong because relative 
			paths are usually relative to the document they're linked in,
			which is not necessarily the library path.""")
			print(path)
		OS.shell_open(path)


func _on_find_entry_text_changed(new_text: String) -> void:
	pass # Replace with function body.


func _on_find_close_pressed() -> void:
	$findpanel.hide()


func _on_markdown_edit_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_find"):
		find()
	if event.is_action_pressed("ui_cancel"):
		%markdown_edit.release_focus()


func _on_findentry_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_find_close_pressed()


func _on_title_pressed() -> void:
	var message := ""
	if current_artefact == null:
		message = "Nothing copied because no document is open."
	else:
		var content = get_title()
		message = "Copied link to document:\n%s" % content
		DisplayServer.clipboard_set(get_title())
	Global.show_notification(message)
