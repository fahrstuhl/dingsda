extends RichTextLabel

func _ready():
	# TODO: this doesn't work yet for some reason
	var panel_theme = get_node("/root/app").theme.get_stylebox("TooltipPanel", "panel")
	print(panel_theme)
	$meta_hover_panel.set("custom_styles/panel", panel_theme)

func _on_rich_text_label_meta_hover_started(meta):
	$meta_hover_panel/meta_hover_text.text = meta
	$meta_hover_timer.start()

func _on_rich_text_label_meta_hover_ended(meta):
	$meta_hover_panel.hide()
	$meta_hover_timer.stop()
	
func _on_meta_hover_timer_timeout():
	$meta_hover_panel.rect_position = get_local_mouse_position() + Vector2(20,0)
	$meta_hover_panel.show()
	$meta_hover_panel.rect_min_size = $meta_hover_panel/meta_hover_text.rect_size
