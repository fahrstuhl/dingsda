extends Node

func get_artefact_type(path: String):
	var ext = path.get_extension()
	var type
	match ext:
		"md", "txt":
			type = ArtefactMarkdown
		"ini":
			if path == Global.settings_path:
				type = ArtefactSettings
			else:
				type = Artefact
		_:
			type = Artefact
	return type

func is_valid_artefact_of_type(path, requested_type):
	var file = File.new()
	var type = get_artefact_type(path)
	if requested_type != type:
		push_error("Type mismatch. Requested {0}, got {1}.".format([requested_type.get_type_name(), type.get_type_name()]))
		return FAILED
	if not file.file_exists(path):
		file.open(path, file.WRITE)
		file.close()
	return OK

func load_artefact(path: String):
	var artefact = find_existing_artefact(path)
	if not artefact:
		var type = get_artefact_type(path)
		artefact = create_artefact(path, type)
		add_child(artefact)
	print(artefact)
	return artefact

func create_artefact(path: String, type):
	var artefact = type.new()
	artefact.init(path)
	return artefact

func find_existing_artefact(path: String):
	for child in get_children():
		if child.path == path:
			return child
	return false
