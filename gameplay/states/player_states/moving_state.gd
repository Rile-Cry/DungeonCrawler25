extends LimboState

func _enter() -> void:
	GameGlobalEvents.game_tick.emit()
	var player = owner as Player
	var target_dir = (player.dir * player.tile_size).rotated(Vector3(0, 1, 0), player.rotation.y)
	var target_pos = player.global_position + target_dir
	
	# TODO: Figure out why the player gets stuck sometimes
	if player.wall_ray:
		player.wall_ray.target_position = target_dir * 1.1
		
		if not player.wall_ray.is_colliding():
			var tween = get_tree().create_tween().bind_node(owner)
			owner.anim_player.play(&"walkingwalker", .1)
			tween.tween_property(owner as Player, "global_position", Vector3(target_pos), owner.anim_player.current_animation_length/1.92)
			await tween.finished
			dispatch(EVENT_FINISHED)
