extends RichTextLabel

var current_artefact: ArtefactMarkdown

func _ready():
	pass

func set_artefact(artefact_path: String):
	if ArtefactManager.is_valid_artefact_of_type(artefact_path, ArtefactMarkdown) == OK:
		var prev_artefact = current_artefact
		current_artefact = ArtefactManager.load_artefact(artefact_path)
		assert(current_artefact is ArtefactMarkdown)
		if prev_artefact != null:
			prev_artefact.rendered.disconnect(_on_artefact_rendered)
		current_artefact.rendered.connect(_on_artefact_rendered)
		current_artefact.render()

func _on_artefact_rendered():
	text = current_artefact.bbcode_text

func _on_rich_text_label_meta_hover_started(meta):
	$meta_hover_panel/meta_hover_text.text = meta
	$meta_hover_timer.start()

func _on_rich_text_label_meta_hover_ended(_meta):
	$meta_hover_panel.hide()
	$meta_hover_timer.stop()
	
func _on_meta_hover_timer_timeout():
	$meta_hover_panel.position = get_local_mouse_position() + Vector2(20,0)
	$meta_hover_panel.show()
	$meta_hover_panel.custom_minimum_size = $meta_hover_panel/meta_hover_text.size
