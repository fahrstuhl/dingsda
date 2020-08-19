extends Artefact

class_name ArtefactMarkdown

var text: String = "" setget set_text
var bbcode_text: String = ""
var file: File

func init(file_path):
	path = file_path
	file = File.new()
	if not file.file_exists(path):
		store_content()
	set_text(load_content())

func set_text(new_text):
	text = new_text
	bbcode_text = Markdown.convert_markdown(new_text)
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

static func get_type_name():
	return "ArtefactMarkdown"
