extends PlayerState

func enter(previous_state_path: StringName, data := {}) -> void:
	print("idling")
	if not GameGlobalEvents.pause_game.is_connected(_on_game_paused):
		GameGlobalEvents.pause_game.connect(_on_game_paused)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"move_forward"):
		finished.emit(MOVING, {&"dir": Vector3i(0, 0, -1)})
	elif event.is_action_pressed(&"move_left"):
		finished.emit(MOVING, {&"dir": Vector3i(-1, 0, 0)})
	elif event.is_action_pressed(&"move_backward"):
		finished.emit(MOVING, {&"dir": Vector3i(0, 0 ,1)})
	elif event.is_action_pressed(&"move_right"):
		finished.emit(MOVING, {&"dir": Vector3i(1, 0, 0)})

func _on_game_paused() -> void:
	GameGlobalEvents.pause_game.disconnect(_on_game_paused)
	finished.emit(PAUSED)
