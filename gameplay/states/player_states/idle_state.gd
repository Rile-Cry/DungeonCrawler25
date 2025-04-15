extends LimboState

func _enter() -> void:
	print("Idling")

func _update(delta: float) -> void:
	var dir := Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	
	if not dir.is_zero_approx():
		if "dir" in owner:
			var v3_dir := Vector3(dir.x, 0, dir.y)
			owner.dir = v3_dir
			dispatch(&"moving")
