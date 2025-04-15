@tool
extends BTAction


## Scan Ahead: Success is returned when there is an empty result ahead, Failure when we have found collision.

## Blackboard variable that stores our scanning_result (Bool)
@export var scanning_wall: StringName = &"scanning_wall"

#
#func _enter() -> void:
	#
	#var scan : bool = blackboard.get_var(scanning_wall, null)
	#if !is_instance_valid(scan):
		#blackboard.get_var(scanning_wall,agent.wall_bonk())
		#


func _tick(delta: float) -> Status:
	# Continue down the line until we DO bonk
	if agent.wall_bonk():
		return FAILURE
	else : return SUCCESS
