extends Node

var settings_path = "user:///settings.ini"
var settings: ArtefactSettings

func _ready():
	settings = ArtefactManager.load_artefact(settings_path)

func get_setting(path):
	return settings.get_setting(path)
