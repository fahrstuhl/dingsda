extends Node

var settings_path = "user:///settings.ini"
var settings: ArtefactSettings

func _ready():
	settings = ArtefactManager.load_artefact(settings_path)

func get_setting(path):
	return settings.get_setting(path)

func add_recent_artefact(path):
	if path == "user:///recent_artefacts.md":
		return
	var recent: Array = settings.get_setting("recent_artefacts")
	var count = recent.count(path)
	for i in range(count):
		var old_index = recent.find(path)
		if old_index != -1:
			recent.remove(old_index)
	recent.push_front(path)
	if len(recent) > get_setting("num_of_recent_artefacts"):
		recent.pop_back()
	settings.set_setting("recent_artefacts", recent)
