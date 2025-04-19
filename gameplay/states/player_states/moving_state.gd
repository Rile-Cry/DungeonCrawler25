extends LimboState

func _enter() -> void:
	GameGlobalEvents.game_tick.emit()
	
	var tween = get_tree().create_tween().bind_node(owner)
	owner.anim_player.play(&"walkingwalker", .1)
	tween.tween_property(owner as Player, "global_position", Vector3(owner.target_dir), owner.anim_player.current_animation_length/1.92)
	await tween.finished
	dispatch(EVENT_FINISHED)
