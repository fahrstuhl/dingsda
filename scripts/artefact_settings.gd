extends Artefact
class_name ArtefactSettings

var config: ConfigFile
var defaults = ConfigFile.new()
var section = "Main"

func set_default_settings():
	config.load("res:///defaults/settings.ini")
	set_setting("library_path", OS.get_user_data_dir())

func add_missing_settings():
	for key in defaults.get_section_keys(section):
		if not config.has_section_key(section, key):
			var value = defaults.get_value(section, key)
			set_setting(key, value)

func get_default_setting(key):
	return defaults.get_value(section, key)

func init(file_path):
	defaults.load("res:///defaults/settings.ini")
	path = file_path
	config = ConfigFile.new()
	var file = File.new()
	if not file.file_exists(path):
		set_default_settings()
	load_content()
	add_missing_settings()

func set_setting(key: String, value):
	print("setting {0} to {1}".format([key, value]))
	config.set_value(section, key, value)
	store_content()
	emit_signal("changed")

func get_setting(key):
	return config.get_value(section, key, get_default_setting(key))

func load_content():
	config.load(path)
	return config

func write_to_file():
	var error = config.save(path)
	if error != OK:
		printerr("Can't save setting.")
