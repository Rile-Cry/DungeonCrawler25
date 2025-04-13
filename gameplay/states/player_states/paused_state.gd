extends PlayerState

func enter(previous_state_path: StringName, data := {}) -> void:
	GameGlobalEvents.resume_game.connect(_on_game_resumed)

func _on_game_resumed() -> void:
	GameGlobalEvents.resume_game.disconnect(_on_game_resumed)
	finished.emit(IDLE)
