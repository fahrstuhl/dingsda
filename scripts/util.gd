extends Node
class_name Util

static func resolve_path(rel_path: String, origin: String):
	if not rel_path.is_relative_path():
		return normalize_path(rel_path)
	var base = origin.get_base_dir()
	var resolved = normalize_path(base.plus_file(rel_path))
	print("Resolved\n{0}\nfrom\n{1}\nto\n{2}\n".format([rel_path, origin, resolved]))
	return resolved

static func normalize_path(path: String):
	var win_drive_regex = RegEx.new()
	win_drive_regex.compile("[a-zA-Z]:/")
	var root
	var abs_path
	if path.is_relative_path():
		root = "/"
		var file = File.new()
		file.open(path, File.READ)
		abs_path = file.get_path_absolute()
		file.close()
	elif path.is_absolute_path():
		abs_path = path
		if win_drive_regex.search(path.substr(0, 3)) != null:
			root = path.substr(0,3)
		elif path.begins_with("/"):
			root = "/"
		elif path.begins_with("user://"):
			root = "user://"
		elif path.begins_with("res://"):
			root = "res://"
	var abs_without_root = abs_path.trim_prefix(root)
	var parts = Array(abs_without_root.split("/", false))
	var norm_path: String = root
	var dot = parts.find(".")
	while dot != -1:
		parts.remove(dot)
		dot = parts.find(".")
	var dotdot = parts.find("..")
	while dotdot != -1:
		parts.remove(dotdot)
		parts.remove(dotdot-1)
		dotdot = parts.find("..")
	for part in parts:
		norm_path = norm_path.plus_file(part)
#	print("Original Path:\n{0}\nAbsolute Path:\n{1}\nNormalized Path:\n{2}".format([path, abs_path, norm_path]))
	return norm_path
