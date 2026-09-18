extends VBoxContainer

var settings: ArtefactSettings

func _ready():
	settings = ArtefactManager.load_artefact(Global.settings_path)
	refresh_settings()
	settings.changed.connect(_on_settings_changed)

func get_title():
	return "Settings"

func _on_settings_changed():
	refresh_settings()

func refresh_settings():
	$settings_container/library_path.current_value = settings.get_setting("library_path")
	var scale : float = settings.get_setting("content_scale")
	var scale_idx : int = (scale - 1.0)/0.25
	$settings_container/content_scale/scale.select(scale_idx)

func _on_close_pressed():
	queue_free()

func _on_library_path_path_changed(path):
	settings.set_setting("library_path", Util.normalize_path(path))


func _on_scale_item_selected(index: int) -> void:
	var scale := clampf(1.0 + 0.25 * index, 1.0, 2.0)
	settings.set_setting("content_scale", scale)
	Global.apply_scale()
