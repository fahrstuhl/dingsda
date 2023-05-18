extends Artefact
class_name ArtefactSettings

var config: ConfigFile
var defaults = ConfigFile.new()
var section = "Main"

func set_default_settings():
	if config.load("res://defaults/settings.ini") != OK:
		printerr("failed to load defaults for config from res://")
	var lib = OS.get_user_data_dir().path_join("wiki")
	if not DirAccess.dir_exists_absolute(lib):
		if DirAccess.make_dir_absolute(lib) != OK:
			printerr("Can't create wiki directory at {0}".format([lib]))
	set_setting("library_path", lib)

func add_missing_settings():
	for key in defaults.get_section_keys(section):
		if not config.has_section_key(section, key):
			var value = defaults.get_value(section, key)
			set_setting(key, value)

func get_default_setting(key):
	return defaults.get_value(section, key)

func init(file_path):
	if defaults.load("res://defaults/settings.ini") != OK:
		printerr("failed to load defaults for defaults from res://")
	path = file_path
	config = ConfigFile.new()
	if not FileAccess.file_exists(path):
		set_default_settings()
	load_content()
	add_missing_settings()

static func is_read_only():
	return false

func set_setting(key: String, value):
#	print("setting {0} to {1}".format([key, value]))
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

func print_config(config_name, config):
	print("Printing config '{0}': {1}".format([config_name, config]))
	for section in config.get_sections():
		print("  Section {0} contains:".format([section]))
		for key in config.get_section_keys(section):
			print("    {0}: {1}".format([key, config.get_value(section, key)]))
