extends BTAction

func _enter() -> void:
	agent.drop_in()
	blackboard.set_var(&"spawned",true)

func _tick(delta: float) -> Status:
	if elapsed_time < 3 :
		return RUNNING
	else : return SUCCESS
