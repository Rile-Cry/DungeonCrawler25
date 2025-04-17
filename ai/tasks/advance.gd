@tool
extends BTAction

@export var path : StringName = &"path"


func _enter() -> void:
	agent.move_bot(blackboard.get_var(path))

func _tick(delta: float) -> Status:
	if elapsed_time < .5:
		return RUNNING
	else : return FAILURE
