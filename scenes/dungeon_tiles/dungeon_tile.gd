class_name DungeonTile extends Node3D

@export var center_position : Marker3D

var map_position : Vector3i

func _ready() -> void:
	add_to_group("tiles")

func read_position(pos: Vector3i) -> void:
	if pos == map_position:
		pass
