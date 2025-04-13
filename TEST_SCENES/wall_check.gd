extends ConditionLeaf

func tick(actor,blackboard) -> int:
	
	if actor.wall_bonk():
		return FAILURE
	return SUCCESS
