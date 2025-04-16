@tool
extends BTAction


## Scan Ahead: Success is returned when there is an empty result ahead, Failure when we have found collision.

## Blackboard variable that stores our scanning_result (Bool)
@export var open_paths: StringName = &"open_paths"

#func _enter() -> void:
	#
	#var path_var = blackboard.get_var(open_paths, null)
	#if is_instance_valid(path_var):
		#print(path_var)
		#print("above is path var")

func _tick(delta: float) -> Status:
	# Continue down the line until we DO bonk
	if !is_instance_valid(open_paths):
		FAILURE
		
	blackboard.set_var(open_paths,agent.path_search())
	#print("Blackboard updated")
	return SUCCESS
