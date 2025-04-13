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

func advance() -> void:
	
	self.set_physics_process(false)
	var move_to : Vector3 = self.position + (Vector3.FORWARD)
	tween_translate(move_to)

func tween_translate(new_pos:Vector3) -> void:
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self,"position",new_pos,3)
	await tween.finished
	pass
