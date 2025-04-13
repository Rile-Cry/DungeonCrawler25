extends ConditionLeaf

func tick(actor,blackboard) -> int:
	
	if actor.wall_bonk():
		print("Im colliding!")
		return FAILURE
	return SUCCESS
