@tool
extends BTAction


## Scan Ahead: Success is returned when there is an empty result ahead, Failure when we have found collision.

## Blackboard variable that stores our scanning_result (Bool)
@export var scanning_wall: StringName = &"scanning_wall"

func _tick(delta: float) -> Status:
	
	var scan : bool = blackboard.get_var(scanning_wall, null)
	if is_instance_valid(scan):
		return FAILURE

	# Continue down the line until we DO bonk
	if agent.wall_bonk():
		return SUCCESS
	else : return FAILURE
