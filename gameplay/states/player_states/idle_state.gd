extends LimboState

func _enter() -> void:
	GameGlobalEvents.game_tick.emit()
	
	if owner.anim_player:
		owner.anim_player.play(&"walkeridle")

func _update(delta: float) -> void:
	var dir := Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	var turn_dir := Input.get_axis(&"turn_left", &"turn_right")
	
	if not dir.is_zero_approx():
		if "dir" in owner:
			owner.dir = Vector3(dir.x, 0, dir.y)
			MoveHandler.move_body(owner)
			if Vector3(owner.target_dir) != owner.global_position:
				dispatch(&"moving")
	
	if Input.is_action_just_pressed("aim"):
		dispatch(&"aiming")
	
	if turn_dir != 0:
		if "turn_dir" in owner:
			owner.turn_dir = turn_dir
			dispatch(&"turning")
