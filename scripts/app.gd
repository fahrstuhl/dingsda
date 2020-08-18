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

