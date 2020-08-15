extends Control

func _ready():
	get_tree().get_root().connect("size_changed", self, "resize")
	resize()

func resize():
	print("resizing")
	$diae_container.rect_size = get_viewport_rect().size
