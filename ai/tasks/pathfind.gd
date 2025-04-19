
@tool
extends BTCondition

## Blackboard variable that holds the target (expecting Node2D).
@export var player_var: StringName = &"player"
@export var path_map : StringName = &"path_map"

# Called to generate a display name for the task.
func _generate_name() -> String:
	return "Generate Pathfind to Player %s" % LimboUtility.decorate_var(player_var)

func _enter() -> void:
	pass
