@tool
extends ProgrammaticTheme

enum Scaling {DESKTOP, MOBILE}
enum Palette {SOLARIZED_LIGHT, SOLARIZED_DARK, GODOT_LIGHT, GODOT_DARK}

var default_font_size = 16
var background_color = Solarized.base00
var foreground_color = Solarized.base1

func set_colors(palette: Palette):
	match palette:
		Palette.SOLARIZED_LIGHT:
			background_color = Solarized.base3
			foreground_color = Solarized.base03
		Palette.SOLARIZED_DARK:
			background_color = Solarized.base00
			foreground_color = Solarized.base1
		Palette.GODOT_LIGHT:
			pass
		Palette.GODOT_DARK:
			pass

func set_scaling(scaling: Scaling):
	match scaling:
		Scaling.DESKTOP:
			default_font_size = 16
		Scaling.MOBILE:
			default_font_size = 32

func set_theme(palette: Palette, scaling: Scaling):
	var name = "{0}_{1}".format([Palette.find_key(palette).to_lower(), Scaling.find_key(scaling).to_lower()])
	set_colors(palette)
	set_scaling(scaling)
	set_save_path("res://themes/{0}.theme".format([name]))

func setup_solarized_dark_desktop_theme():
	set_theme(Palette.SOLARIZED_DARK, Scaling.DESKTOP)

func setup_solarized_dark_mobile_theme():
	set_theme(Palette.SOLARIZED_DARK, Scaling.MOBILE)

func setup_solarized_light_desktop_theme():
	set_theme(Palette.SOLARIZED_LIGHT, Scaling.DESKTOP)
	
func setup_solarized_light_mobile_theme():
	set_theme(Palette.SOLARIZED_LIGHT, Scaling.MOBILE)

func define_theme():
	define_style("RichTextLabel", {
		default_color = foreground_color,
		normal_font_size = default_font_size
	})
	define_style("TextEdit", {
		background_color = background_color,
		font_color = foreground_color,
		font_size = default_font_size
	})
