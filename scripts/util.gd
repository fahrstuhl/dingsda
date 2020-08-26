extends Node
class_name Util

static func normalize_path(path: String):
	var root
	var abs_path
	if path.is_rel_path():
		root = "/"
		var file = File.new()
		file.open(path, File.READ)
		abs_path = file.get_path_absolute()
		file.close()
	elif path.is_abs_path():
		abs_path = path
		if path.begins_with("/"):
			root = "/"
		elif path.begins_with("user://"):
			root = "user://"
		elif path.begins_with("res://"):
			root = "res://"
	var abs_without_root = abs_path.trim_prefix(root)
	var parts = Array(abs_without_root.split("/", false))
	var norm_path = root
	var dotdot = parts.find("..")
	while dotdot != -1:
		parts.remove(dotdot)
		parts.remove(dotdot-1)
		dotdot = parts.find("..")
	for part in parts:
		norm_path = norm_path.plus_file(part)
	# print("Original Path:\n{0}\nAbsolute Path:\n{1}\nNormalized Path:\n{2}".format([path, abs_path, norm_path]))
	return norm_path
