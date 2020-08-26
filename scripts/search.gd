extends Node

func search(string, path):
	var abs_path = Util.normalize_path(path)
	var filenames = get_filenames(abs_path, true)
	var abs_names = prefix_filenames(filenames, abs_path)
	var content_searchable = filter_content_searchable(abs_names)
	var metadata_searchable = filter_metadata_searchable(abs_names)
	var results = {
		"files": search_filenames(string, filenames),
		"metadata": search_metadata(string, metadata_searchable),
		"content": search_content(string, content_searchable),
	}
	return results

func get_filenames(path, recursive):
	var dir: Directory = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true, true)
	var current = dir.get_next()
	var filenames = []
	var dirnames = []
	while current != "":
		if recursive and dir.current_is_dir():
			var sub_path = path.plus_file(current)
			var sub_filenames = get_filenames(sub_path, true)
			for sub in sub_filenames:
				filenames.append(current.plus_file(sub))
		else:
			filenames.append(current)
		current = dir.get_next()
	return filenames

func prefix_filenames(filenames, prefix):
	var abs_names = []
	for file in filenames:
		abs_names.append(prefix.plus_file(file))
	return abs_names

func search_filenames(string, filenames):
	var results = []
	for file in filenames:
		if file.findn(string) != -1:
			results.append(file)
	return results

func search_content(string, filenames):
	var results = {}
	for path in filenames:
		var artefact = ArtefactManager.load_artefact(path, false)
		if string in artefact.text:
			results[path] = ""
	return results

func search_metadata(string, filenames):
	var results = {}
	for path in filenames:
		var artefact = ArtefactManager.load_artefact(path, false)
		var metadata = artefact.get_metadata()
		for key in metadata:
			if string in metadata[key]:
				if not results.has(path):
					results[path] = []
				results[path].append(key)
	return results

func filter_content_searchable(filenames):
	var result = []
	for file in filenames:
		if ArtefactManager.is_valid_artefact_of_type(file, ArtefactMarkdown) == OK:
			result.append(file)
	return result

func filter_metadata_searchable(filenames):
	return filter_content_searchable(filenames)
