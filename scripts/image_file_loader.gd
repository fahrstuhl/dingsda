# tool
extends ResourceFormatLoader
class_name ImageFileLoader

func _handles_type(typename: String):
	return typename == "ImageTexture"

func _load(path: String, _original_path: String, _use_sub_threads: bool, _cache_mode: int):
	print("Custom loader called.")
	var image = Image.new()
	var texture = ImageTexture.new()
	var err = image.load(path)
	if err != OK:
		return err
	else:
		texture.create_from_image(image)
		texture.take_over_path(path)
		return texture

func _get_resource_type(path):
	if path.get_extension() in ["bmp", "dds", "exr", "hdr", "jpg", "jpeg", "png", "tga", "svg", "svgz", "webp"]:
		return "ImageTexture"
	else:
		return ""

func _get_recognized_extensions():
	return Array(["bmp", "dds", "exr", "hdr", "jpg", "jpeg", "png", "tga", "svg", "svgz", "webp"])
