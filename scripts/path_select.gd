extends HBoxContainer

export var setting_name: String = "some_setting_path"
export var setting_description: String = "Long description for some setting."
export var default_value: String = "user:///"
export var current_value: String = "user:///" setget set_current_value

signal path_changed(path)

func _ready():
	$setting_name.text = setting_name
	$setting_name.hint_tooltip = setting_description

func set_current_value(dir):
	current_value = dir
	$current_path.text = current_value
	$dir_dialog.current_dir = current_value
	$dir_dialog.current_path = current_value

func _on_open_dir_dialog_pressed():
	$dir_dialog.popup_centered_ratio()

func _on_dir_dialog_dir_selected(dir):
	save_setting(dir)

func _on_current_path_text_entered(dir):
	save_setting(dir)

func _on_save_pressed():
	save_setting($current_path.text)

func save_setting(dir):
	set_current_value(dir)
	emit_signal("path_changed", current_value)
