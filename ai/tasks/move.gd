@tool
extends BTAction

@export var open_paths : StringName = &"open_paths"

func _enter() -> void:
	var pick_a_dir = blackboard.get_var(open_paths,null)
	var rand = randi_range(0,pick_a_dir.size()-1)
	print(pick_a_dir)
	if randi_range(0,100) > 50 and pick_a_dir[0] == 0: agent.move_bot(0)
	else :
		agent.move_bot(pick_a_dir[rand])

func _tick(delta: float) -> Status:
	if elapsed_time < .5:
		return RUNNING
	else : return SUCCESS
