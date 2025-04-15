extends LimboState

func _enter() -> void:
	print("Moving")
	
	var tween = get_tree().create_tween().bind_node(owner)
	tween.tween_property(owner as Player, "global_position", Vector3(owner.target_dir), 0.5)
	await tween.finished
	dispatch(EVENT_FINISHED)
