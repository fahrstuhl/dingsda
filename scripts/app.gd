extends Control

func _ready():
	print(theme)
	if OS.get_name() == "Android":
		OS.request_permissions()
	get_tree().get_root().connect("size_changed", self, "resize")
	resize()

func resize():
	print("resizing")
	$diae_container.rect_size = get_viewport_rect().size

# TODO
func create_and_open_recent_artefacts_document():
	var file = File.new()
	file.open("res:///defaults/recent_artefacts.md.template", File.READ)
	var template = file.get_as_text()
	file.close()
	var recent = Global.get_setting("recent_artefacts")
	var recent_string = ""
	for artefact in recent:
		pass
	print(template)
	var formatted = template.format({recent)
	file.open("user:///recent_artefacts.md", File.WRITE)
	file.store_string(formatted)
	file.close()
	$diae_container.open_artefact("user:///recent_artefacts.md")
