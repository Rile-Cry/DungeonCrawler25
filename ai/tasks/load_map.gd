extends BTAction

func _enter() -> void:
	if blackboard.get_var("CurrentMap",null):
		blackboard.set_var("CurrentMap", agent.get_map())
