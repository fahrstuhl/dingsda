extends FoldableContainer

const task_scene := preload("res://scenes/kanban_task.tscn")
var status_lists :Dictionary[StringName, Control]

@export var project: KanbanProject:
	set(value):
		project = value
		if not is_node_ready():
			await self.ready
		title = project.name
		for status in project.statuses:
			var status_list := VBoxContainer.new()
			status_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			status_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
			status_list.name = status
			status_lists[status] = status_list
			%Statuses.add_child(status_list)
			var empty_placeholder := Control.new()
			empty_placeholder.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			status_list.add_child(empty_placeholder)
		for task in project.tasks:
			if task.status in status_lists:
				var task_list := status_lists[task.status]
				var task_ctrl := task_scene.instantiate()
				task_list.add_child(task_ctrl)
				task_ctrl.task = task
