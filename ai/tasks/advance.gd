@tool
extends BTAction


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	
	agent.advance()
	if elapsed_time > .5 or agent.rays[0].is_colliding():
		return FAILURE
	return RUNNING
