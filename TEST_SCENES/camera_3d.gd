extends Camera3D


@export var bot: CharacterBody3D
@export var facing: RichTextLabel
@export var current_dir : RichTextLabel
@export var bot_rotation : RichTextLabel
@export var bot_g_rotation : RichTextLabel
@export var bot_l_rotation : RichTextLabel

func _process(delta: float) -> void:
	look_at(bot.global_position,Vector3.UP)
	facing.text = "Bot Facing: " + str(bot.get_facing())
	current_dir.text = "Current Dir: " + str(bot.current_dir)
	bot_rotation.text = "Bot Rotation: " + str(bot.rotation)
	bot_g_rotation.text = "Bot Global Rotation: " + str(bot.global_rotation)
	bot_l_rotation.text = "Bot Local Rotation: " + str(bot.to_local(rotation))
