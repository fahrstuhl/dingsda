extends ScrollContainer

const project_scene := preload("res://scenes/kanban_project.tscn")
var current_artefact: ArtefactMarkdown

var kanban_document: KanbanDocument:
	set(value):
		kanban_document = value
		for child in %Projects.get_children():
			if child == %Statuses:
				continue
			child.queue_free()
		for child in %Statuses.get_children():
			child.queue_free()
		if not is_node_ready():
			await self.ready
		for status in kanban_document.status_order:
			var status_label := Label.new()
			status_label.text = status
			status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			status_label.size_flags_vertical = Control.SIZE_EXPAND
			%Statuses.add_child(status_label)
		for project: KanbanProject in kanban_document.projects:
			var project_ctrl = project_scene.instantiate()
			%Projects.add_child(project_ctrl)
			project_ctrl.project = project

func set_artefact(artefact_path: String):
	if ArtefactManager.is_valid_artefact_of_type(artefact_path, ArtefactMarkdown) == OK:
		var prev_artefact = current_artefact
		current_artefact = ArtefactManager.load_artefact(artefact_path)
		assert(current_artefact is ArtefactMarkdown)
		if prev_artefact != null:
			prev_artefact.changed.disconnect(_on_artefact_changed)
		current_artefact.changed.connect(_on_artefact_changed)
		_on_artefact_changed()

func _on_artefact_changed():
	kanban_document = KanbanDocument.from_markdown_text(current_artefact.text)
