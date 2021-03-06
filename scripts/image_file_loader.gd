tool
extends ResourceFormatLoader
class_name ImageFileLoader

func handles_type(typename: String):
	return typename == "ImageTexture"

func load(path, original_path):
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

func get_resource_type(path):
	if path.get_extension() in ["bmp", "dds", "exr", "hdr", "jpg", "jpeg", "png", "tga", "svg", "svgz", "webp"]:
		return "ImageTexture"
	else:
		return ""

func get_recognized_extensions():
	return PoolStringArray(["bmp", "dds", "exr", "hdr", "jpg", "jpeg", "png", "tga", "svg", "svgz", "webp"])
