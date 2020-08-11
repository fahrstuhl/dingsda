extends HSplitContainer

var current_artefact: ArtefactMarkdown

func _ready():
	current_artefact = get_node("/root/app/artefact_manager").load_artefact("res://examples/test.md")
	current_artefact.connect("changed", self, "_on_artefact_changed")
	$text_edit.text = current_artefact.text
	$text_edit.emit_signal("text_changed")	

func _on_text_edit_text_changed():
	$rich_text_label.bbcode_text = $text_edit.text
	if not $text_edit.readonly:
		current_artefact.text = $text_edit.text

func _on_artefact_changed():
	if $text_edit.readonly:
		$text_edit.text = current_artefact.text

func _on_text_edit_focus_entered():
	$text_edit.readonly = false

func _on_text_edit_focus_exited():
	$text_edit.readonly = true
