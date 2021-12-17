extends Node
class_name Artefact

signal changed
signal rendered

var path: String
var max_time_without_saving: float = 3*60
var idle_save_time: float = 30
var render_time: float = 5
var idle_save_timer: Timer = Timer.new()
var autosave_timer: Timer = Timer.new()
var render_timer: Timer = Timer.new()

#virtual
func init(file_path):
	path = file_path

#virtual
func write_to_file():
	pass

#virtual
func load_content():
	pass

#virtual
func render():
	pass

#virtual
static func is_read_only():
	return true

func _ready():
	add_child(autosave_timer)
	add_child(idle_save_timer)
	add_child(render_timer)
	idle_save_timer.one_shot = true
	autosave_timer.one_shot = true
	render_timer.one_shot = true
	# save after there has been no edit to the document in idle_save_time seconds
	idle_save_timer.timeout.connect(_on_autosave_timeout)
	# save after there was no save in the last max_time_without_saving seconds
	autosave_timer.timeout.connect(_on_autosave_timeout)
	changed.connect(_on_changed)
	# save when artefact is being closed
	tree_exiting.connect(_on_tree_exiting)
	render_timer.timeout.connect(_on_render_timeout)

static func get_type_name():
	return "Artefact"

func render_content():
	render_timer.stop()
#	print("rendering")
	render()

func store_content():
#	print("saving")
	autosave_timer.stop()
	idle_save_timer.stop()
	write_to_file()

func _on_changed():
#	print("starting idle save timer")
	start_idle_save_timer()
	if autosave_timer.is_stopped():
		start_autosave_timer()
#		print("starting autosave timer")
#	print("start rendering timer")
	start_render_timer()

func _on_autosave_timeout():
#	print("autosaving")
	store_content()

func _on_tree_exiting():
#	print("exit called")
	store_content()

func _on_render_timeout():
	render_content()

func start_idle_save_timer():
	idle_save_timer.start(idle_save_time)

func start_autosave_timer():
	autosave_timer.start(max_time_without_saving)

func start_render_timer():
	if render_timer.is_stopped():
		render_timer.start(render_time)
