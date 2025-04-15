extends Camera3D


@export var bot: CharacterBody3D


func _process(delta: float) -> void:
	look_at(bot.global_position,Vector3.UP)
