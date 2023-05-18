extends Control

func _ready():
	print(theme)
	if OS.get_name() == "Android":
		OS.request_permissions()
	get_tree().get_root().size_changed.connect(resize)
	resize()
	create_and_open_recent_artefacts_document()

func resize():
	print("resizing")
#	$editor_container.size = get_viewport_rect().size
	
func create_and_open_recent_artefacts_document():
	var file = FileAccess.open("res://defaults/recent_artefacts.md.template", FileAccess.READ)
	var template = file.get_as_text()
	print(template)
	file.close()
	var recent = Global.get_setting("recent_artefacts")
	var recent_string = ""
	for artefact in recent:
		var title = artefact.get_file()
		var link = artefact
		recent_string += "1. [{title}](<{link}>)\n".format({"title": title, "link": link})
	var formatted = template.format({"recent_documents": recent_string})
	file = FileAccess.open("user://recent_artefacts.md", FileAccess.WRITE)
	file.store_string(formatted)
	file.close()
	$editor_container.open_artefact("user://recent_artefacts.md")
