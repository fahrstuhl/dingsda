extends PanelContainer

@export var task: KanbanTask:
	set(value):
		task = value
		if not is_node_ready():
			await self.ready
		%Done.button_pressed = task.done
		%Text.text = task.text
		%Done.disabled = true
