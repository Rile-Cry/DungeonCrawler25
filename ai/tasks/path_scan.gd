@tool
extends BTAction

## Blackboard variable that stores our open_path (Array of ints)
@export var open_paths: StringName = &"open_paths"
@export var forward_path_check : StringName = &"forward_path_check"

func _generate_name() -> String:
	return "Scan path %s" % LimboUtility.decorate_output_var(open_paths) + " and %s" %LimboUtility.decorate_output_var(forward_path_check)

func _enter() -> void:
	
	var temp = agent.path_search()
	blackboard.set_var(open_paths,temp)
	if temp[0] == 0:
		blackboard.set_var(forward_path_check,true)
	else : blackboard.set_var(forward_path_check,false)
