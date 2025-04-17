@tool
extends BTAction

@export var open_paths : StringName = &"open_paths"

func _enter() -> void:
	var pick_a_dir = blackboard.get_var(open_paths,null)
	agent.move_bot(pick_a_dir[randi_range(0,pick_a_dir.size()-1)])

func _tick(delta: float) -> Status:
	if elapsed_time < .5:
		return RUNNING
	else : return SUCCESS
