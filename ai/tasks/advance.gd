@tool
extends BTAction


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	
	agent.advance()
	if elapsed_time > .5:
		print("Agent Facing: " + str(agent.get_facing()) + " to Advance has finished")
		return FAILURE
	elif agent.wall_bonk():
		return FAILURE
	return RUNNING
