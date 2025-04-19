extends LimboState

func _enter() -> void:
	GameGlobalEvents.game_tick.emit()
	
	var player = owner as Player
	player.anim_player.play(&"walkeraimstart")
	await player.anim_player.animation_finished
	player.anim_player.play(&"walkeraiming")

func _update(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		owner.anim_player.play(&"walkerfiring")
		await owner.anim_player.animation_finished
		
		GameGlobalEvents.game_tick.emit()
	
	if Input.is_action_just_pressed("aim"):
		owner.anim_player.play_backwards(&"walkeraimstart")
		await owner.anim_player.animation_finished
		dispatch(EVENT_FINISHED)
