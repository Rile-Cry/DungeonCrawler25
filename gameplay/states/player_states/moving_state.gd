extends PlayerState

func enter(previous_state_path: StringName, data := {}) -> void:
	await GameGlobal.delay(2)
	finished.emit(IDLE)
