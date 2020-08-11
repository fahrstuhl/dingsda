extends Node

func load_artefact(path: String):
	var type = path.get_extension()
	print(type)
	var artefact = find_existing_artefact(path)
	if not artefact:
		match type:
			"md", "txt":
				artefact = ArtefactMarkdown.new()
				print("recognized markdown")
			_:
				artefact = Artefact.new()
				print("loading generic artefact")
		artefact.init(path)
		add_child(artefact)
	print(artefact)
	return artefact

func find_existing_artefact(path: String):
	for child in get_children():
		if child.path == path:
			return child
	return false
