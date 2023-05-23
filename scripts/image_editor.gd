extends Container

var current_artefact: ArtefactImage
var active = false

signal open_artefact(artefact_path)
signal name_changed

func set_artefact(artefact_path: String):
	if ArtefactManager.is_valid_artefact_of_type(artefact_path, ArtefactImage) == OK:
		var prev_artefact = current_artefact
		current_artefact = ArtefactManager.load_artefact(artefact_path)
		assert(current_artefact is ArtefactImage)
		%image_view.texture = current_artefact.texture
		change_name()

func change_name():
	$buttons/title.set_text(get_title())
	emit_signal("name_changed")

func get_title():
	var title = "Image Editor"
	if not current_artefact == null:
		title = current_artefact.path
		var library_path = Global.get_setting("library_path")
		if title.begins_with(library_path):
			title = "<library_path>" + title.trim_prefix(library_path)
	return title

func _on_file_dialog_file_selected(path):
	set_artefact(path)

func _on_open_pressed():
	$file_dialog.popup_centered_ratio()

func _on_close_pressed():
	queue_free()
