extends Control



func _ready():
	var editor = preload("res://scenes/split_text_editor.tscn")
	for i in range(3):
		var scene = editor.instance()
		$diae_container.add_container(scene)
		scene.set_artefact("res://examples/test.md")
