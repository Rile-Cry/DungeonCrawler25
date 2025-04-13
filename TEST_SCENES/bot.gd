class_name Bot

extends RigidBody3D

@export var ray_box:Node3D
var rays : Array[RayCast3D]


func _ready() -> void:
	
	## Rays
	# 0 = Front, 1 = Right, 2 = Back, 3 = Left
	for r in ray_box.get_children():
		rays.append(r)

func get_pos() -> Vector3:
	return self.position

func wall_bonk() -> bool:
	if rays[0].is_colliding() :
		return true
	return false

func get_delta() -> float :
	return get_process_delta_time()
