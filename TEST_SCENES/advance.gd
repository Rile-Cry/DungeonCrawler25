extends ActionLeaf

func tick(actor,blackboard) -> int :
	actor.advance()
	return SUCCESS
