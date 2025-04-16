@tool
extends BTAction

# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	
	var paths = blackboard.get_var(&"open_paths",null)
	var dir : int
	if paths[0] == 0:
		agent.advance()
	else : agent.tween_rotate(randi_range(paths[0],(paths.size()-1)))
	if elapsed_time > .5:
		return SUCCESS
	return RUNNING
