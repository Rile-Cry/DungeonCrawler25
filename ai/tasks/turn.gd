@tool
extends BTAction

# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	if agent.wall_bonk():
		var dir = agent.turn()
		agent.tween_rotate(dir)
	if elapsed_time > .5:
		return SUCCESS
	return RUNNING
