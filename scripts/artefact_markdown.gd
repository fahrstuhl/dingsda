extends Artefact

class_name ArtefactMarkdown

var text: String = "":
	set = set_text
var bbcode_text: String = ""
var file: File

func init(file_path):
	path = file_path
	file = File.new()
	if not file.file_exists(path):
		store_content()
	set_text(load_content())

static func is_read_only():
	return false

func set_text(new_text):
	text = new_text
	emit_signal("changed")

func load_content():
	var error = file.open(path, File.READ)
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
	var error = file.open(path, File.WRITE)
	if error != OK:
		printerr("Can't open file for writing.")
	else:
		file.store_string(text)
		file.close()

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
#		if ArtefactManager.is_valid_artefact_of_type(img_path, ArtefactImage):
#			print("valid image")
		var img_artefact = ArtefactManager.load_artefact(img_path, false)
		if img_artefact is ArtefactImage:
#			print("loaded image:")
#			print(img_artefact.get_resource_path())
			replace_links[original_path] = "]" + img_path + "["
	bbcode_text = bbcode_text.format(replace_links, replace_format)
#	print(bbcode_text)
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
