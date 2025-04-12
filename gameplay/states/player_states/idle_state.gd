extends PlayerState

func enter(previous_state_path: StringName, data := {}) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"select"):
		finished.emit(MOVING)
