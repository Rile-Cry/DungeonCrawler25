extends ActionLeaf

func tick(actor,blackboard)->int:
	actor.tween_rotate(Vector3.BACK)
	return SUCCESS
	
