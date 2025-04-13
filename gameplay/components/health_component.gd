extends Node

@export var hp : int = 0
@export var defense_component : Node

func damage(value: int) -> void:
	if defense_component:
		hp -= (value - defense_component.def)
	else:
		hp -= value
	
	if owner is Player:
		owner.damaged.emit()

func heal(value: int) -> void:
	hp += value
