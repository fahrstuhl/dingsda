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
		"bmp", "dds", "exr", "hdr", "jpg", "jpeg", "png", "tga", "svg", "svgz", "webp":
			type = ArtefactImage
		_:
			type = Artefact
	return type

func is_valid_artefact_of_type(path, requested_type):
	var type = get_artefact_type(path)
	if requested_type.get_type_name() != type.get_type_name():
		push_error("Type mismatch. Requested {0}, got {1}.".format([requested_type.get_type_name(), type.get_type_name()]))
		return FAILED
	return OK

func load_artefact(path: String, update_recent: bool = true):
	path = Util.normalize_path(path)
	var artefact = find_existing_artefact(path)
	var type = get_artefact_type(path)
	var file = File.new()
	if not file.file_exists(path):
		if type.is_read_only():
			type = Artefact
	if not artefact:
		artefact = create_artefact(path, type)
		add_child(artefact)
	if update_recent and type != ArtefactSettings:
		Global.add_recent_artefact(path)
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
