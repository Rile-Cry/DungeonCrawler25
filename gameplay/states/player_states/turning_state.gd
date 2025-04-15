extends LimboState

func _enter() -> void:
	var tween := get_tree().create_tween().bind_node(owner)
	tween.tween_property(owner as Node3D, "rotation_degrees", owner.rotation_degrees + Vector3(0, 90 * -owner.turn_dir, 0), 0.5)
	await tween.finished
	dispatch(EVENT_FINISHED)
