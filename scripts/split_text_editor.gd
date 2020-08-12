extends Container

var current_artefact: ArtefactMarkdown

func set_artefact(artefact_path: String):
	var artefact_manager = get_node("/root/app/artefact_manager")
	print(artefact_manager)
	current_artefact = artefact_manager.load_artefact(artefact_path)
	current_artefact.connect("changed", self, "_on_artefact_changed")
	$editor/text_edit.text = current_artefact.text
	_on_text_edit_focus_exited()
	_on_text_edit_text_changed()

func _on_text_edit_text_changed():
	$editor/rich_text_label.bbcode_text = $editor/text_edit.text
	if not $editor/text_edit.readonly:
		current_artefact.text = $editor/text_edit.text

func _on_artefact_changed():
	if $editor/text_edit.readonly:
		$editor/text_edit.text = current_artefact.text
		$editor/rich_text_label.bbcode_text = $editor/text_edit.text

func _on_text_edit_focus_exited():
	$editor/text_edit.readonly = true
	$editor/text_edit.hide()
	$editor/rich_text_label.show()

func _on_rich_text_label_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.doubleclick:
		$editor/text_edit.readonly = false
		$editor/rich_text_label.hide()
		$editor/text_edit.show()
		$editor/text_edit.grab_focus()

func _on_close_pressed():
	queue_free()

func _on_file_dialog_file_selected(path):
	set_artefact(path)

func _on_open_pressed():
	$file_dialog.popup_centered_ratio() # Replace with function body.
