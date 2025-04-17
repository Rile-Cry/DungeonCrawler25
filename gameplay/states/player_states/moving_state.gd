extends LimboState

func _enter() -> void:
	var tween = get_tree().create_tween().bind_node(owner)
	owner.anim_player.play(&"walkingwalker")
	tween.tween_property(owner as Player, "global_position", Vector3(owner.target_dir), owner.anim_player.current_animation_length)
	await tween.finished
	dispatch(EVENT_FINISHED)
