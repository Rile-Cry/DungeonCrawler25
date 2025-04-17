@tool
extends BTAction

## Blackboard variable that stores our open_path (Array of ints)
@export var open_paths: StringName = &"open_paths"

func _enter() -> void:
	var temp = agent.path_search()
	blackboard.set_var(open_paths,temp)
