extends Container

var current_artefact: ArtefactMarkdown
var active = false

signal open_artefact(artefact_path)
signal name_changed

func _ready():
	$file_dialog.current_dir = Global.get_setting("library_path")

func get_title():
	if not current_artefact == null:
		return current_artefact.path
	else:
		return "Markdown Editor"

func set_artefact(artefact_path: String):
	active = false
	if ArtefactManager.is_valid_artefact_of_type(artefact_path, ArtefactMarkdown) == OK:
		current_artefact = ArtefactManager.load_artefact(artefact_path)
		assert(current_artefact is ArtefactMarkdown)
		current_artefact.connect("changed", self, "_on_artefact_changed")
		$editor/text_edit.text = current_artefact.text
		_on_text_edit_focus_exited()
		_on_text_edit_text_changed()
		active = true
		name_changed()

func name_changed():
	$buttons/title.set_text(get_title())
	emit_signal("name_changed")

func _on_text_edit_text_changed():
	if not $editor/text_edit.readonly:
		current_artefact.text = $editor/text_edit.text
	$editor/rich_text_label.bbcode_text = current_artefact.bbcode_text

func _on_artefact_changed():
	if $editor/text_edit.readonly:
		$editor/text_edit.text = current_artefact.text
		$editor/rich_text_label.bbcode_text = current_artefact.bbcode_text

func _on_text_edit_focus_exited():
	$editor/text_edit.readonly = true
	$editor/text_edit.hide()
	$editor/rich_text_label.show()
	current_artefact.store_content()

func _on_rich_text_label_gui_input(event):
	if active:
		var doubleclick = event is InputEventMouseButton and event.is_pressed() and event.doubleclick
		var two_finger_touch = event is InputEventScreenTouch and event.is_pressed() and event.index == 1
		if doubleclick or two_finger_touch:
			start_editing()

func start_editing():
	$editor/text_edit.readonly = false
	$editor/rich_text_label.hide()
	$editor/text_edit.show()
	$editor/text_edit.grab_focus()

func _on_close_pressed():
	queue_free()

func _on_file_dialog_file_selected(path):
	set_artefact(path)

func _on_open_pressed():
	$file_dialog.popup_centered_ratio()

func _on_rich_text_label_meta_clicked(meta: String):
	if meta.begins_with("#"):
		var artefact_name = "{0}.md".format([meta])
		artefact_name.erase(0, 1)
		var path = "{0}{1}".format([Global.get_setting("library_path"), artefact_name])
		emit_signal("open_artefact", path)
