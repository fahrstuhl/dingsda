extends Artefact

class_name ArtefactMarkdown

var text: String = "":
	set = set_text
var bbcode_text: String = ""
var is_changed_since_last_store := false

func init(file_path):
	path = file_path
	if not FileAccess.file_exists(path):
		is_changed_since_last_store = true
		store_content()
	set_text(load_content())
	is_changed_since_last_store = false

static func is_read_only():
	return false

func set_text(new_text):
	text = new_text
	is_changed_since_last_store = true
	emit_signal("changed")

func load_content():
	var file = FileAccess.open(path, FileAccess.READ)
	var error = file.get_error()
	var result = ""
	if error != OK:
		printerr(path)
		printerr(error)
		printerr("Can't read file.")
	else:
		result = file.get_as_text()
		file.close()
	return result

func write_to_file():
	if !is_changed_since_last_store:
		print_verbose("Not writing unchanged file %s" % path)
		return
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file.get_error() != OK:
		printerr("Can't open file for writing.")
	else:
		file.store_string(text)
		file.close()
		is_changed_since_last_store = false
		print_verbose("Saved changed file %s" % path)

func render():
	bbcode_text = Markdown.convert_markdown(text)
	var re = RegEx.new()
	re.compile("\\[img.*\\](?P<path>.*)\\[\\/img\\]")
	var imgs = re.search_all(bbcode_text)
	var replace_links = {}
	var replace_format = "]_["
	for img in imgs:
		var original_path = img.get_string("path")
		var img_path = Util.resolve_path(img.get_string("path"), path)
		emit_signal("request_load", img_path, false)
		replace_links[original_path] = "]" + img_path + "["
	bbcode_text = bbcode_text.format(replace_links, replace_format)
	emit_signal("rendered")

func get_metadata():
	var metadata = {}
	var regex = RegEx.new()
	regex.compile("\\[_metadata_:(?P<key>.*)\\]: <(?P<value>.*)>")
	var results = regex.search_all(text)
	for result in results:
		var key = result.get_string("key")
		var value = result.get_string("value")
		metadata[key] = value
	return metadata

static func get_type_name():
	return "ArtefactMarkdown"
