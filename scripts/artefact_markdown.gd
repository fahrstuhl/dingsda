extends Artefact

class_name ArtefactMarkdown

var text: String = "" setget set_text
var file: File

func init(file_path):
	path = file_path
	file = File.new()
	if not file.file_exists(path):
		store_text()
	set_text(load_text())

func set_text(new_text):
	text = new_text
	emit_signal("changed")
	store_text()

func load_text():
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

func store_text():
	var error = file.open(path, File.WRITE)
	if error != OK:
		printerr("Can't open file for writing.")
	else:
		file.store_string(text)
		file.close()
