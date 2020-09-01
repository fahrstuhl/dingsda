extends Artefact
class_name ArtefactImage

var texture: ImageTexture

func init(file_path):
	path = file_path
	load_content()

func write_to_file():
	pass

func load_content():
	texture = ResourceLoader.load(path, "ImageTexture")

func get_resource_path():
	return texture.resource_path

func render():
	pass

static func is_read_only():
	return true
