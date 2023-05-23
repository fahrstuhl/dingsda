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
		title = current_artefact.path
		var library_path = Global.get_setting("library_path")
		if title.begins_with(library_path):
			title = "<library_path>" + title.trim_prefix(library_path)
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
		$editor/rich_text_label.set_artefact(artefact_path)
		%text_edit.text = current_artefact.text
		_on_text_edit_focus_exited()
		_on_text_edit_text_changed()
		active = true
		change_name()

func change_name():
	$buttons/title.set_text(get_title())
	emit_signal("name_changed")

func _on_text_edit_text_changed():
	if %text_edit.editable:
		current_artefact.text = %text_edit.text

func _on_artefact_changed():
	if not %text_edit.editable:
		%text_edit.text = current_artefact.text

func _on_text_edit_focus_exited():
	var ratio = %text_edit.get_v_scroll_bar().ratio
	%text_edit.editable = false
	%text_edit.hide()
	$editor/rich_text_label.show()
	$editor/rich_text_label.get_v_scroll_bar().ratio = ratio
	current_artefact.render_content()
	current_artefact.store_content()

func _on_rich_text_label_gui_input(event):
	if active:
		var click = event is InputEventMouseButton and event.is_pressed()
		var singleclick = click and not event.is_double_click()
		var doubleclick = click and event.is_double_click()
		var two_finger_touch = event is InputEventScreenTouch and event.is_pressed() and event.index == 1
		if doubleclick or two_finger_touch:
			start_editing()

func get_approximate_line(pos: Vector2):
	var bar: VScrollBar = $editor/rich_text_label.get_v_scroll_bar()
	var ratio = bar.ratio
	var max_y = $editor/rich_text_label.get_content_height()
	var top_y = ratio * max_y
	var n_lines = $editor/rich_text_label.get_line_count()
	var v_lines = $editor/rich_text_label.get_visible_line_count()
	var top_line = ratio * n_lines
	var y = pos.y
	var clicked_y = top_y + y
	var rel_y = clamp(clicked_y / max_y, 0.0, 1.0)
	var clicked_line = min(rel_y * n_lines, n_lines)
	var debug_output = """{0}px / {1}px = {2}
	Ratio {3}
	Top Y: {4}, Clicked Y: {5}, Max y : {6}
	Top line: {7}, Clicked line: {8}, Max line: {9}
	""".format([
				y, size.y, rel_y,
				ratio,
				top_y, clicked_y, max_y,
				top_line, clicked_line, n_lines
				])
	return ratio

func start_editing():
	%text_edit.editable = true
	$editor/rich_text_label.hide()
	%text_edit.show()
	%text_edit.grab_focus()
	%text_edit.get_v_scroll_bar().ratio = $editor/rich_text_label.get_v_scroll_bar().ratio

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
		var path = library_path.plus_file(artefact_name)
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
			path = Util.normalize_path(library_path.plus_file(meta))
			path = "file://".path_join(path)
			printerr("""Relative path handling is still wrong because relative 
			paths are usually relative to the document they're linked in,
			which is not necessarily the library path.""")
			print(path)
		OS.shell_open(path)
