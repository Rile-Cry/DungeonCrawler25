extends PlayerState

func enter(previous_state_path: StringName, data := {}) -> void:
	print(data)
	GameGlobalEvents.game_tick.emit()
	await GameGlobal.delay(2)
	finished.emit(IDLE)
