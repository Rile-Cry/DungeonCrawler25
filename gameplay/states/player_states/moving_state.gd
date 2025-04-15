extends LimboState

func _enter() -> void:
	print("Moving")
	
	var tween = get_tree().create_tween()
	tween.tween_property(owner as Node3D, "position", owner.dir + owner.position, 2)
	await tween.finished
	dispatch(EVENT_FINISHED)
