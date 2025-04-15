class_name Bot

extends CharacterBody3D

@export var ray_box:Node3D
var rays : Array[RayCast3D]
var scanning_wall : bool = false
@onready var tweener:Tween
var facing : Array[StringName] = ["north","east","south","west"]
var current_dir:StringName = "north"

func _ready() -> void:
	## Rays
	# 0 = Front, 1 = Right, 2 = Back, 3 = Left
	for r in ray_box.get_children():
		rays.append(r)
		
func toggle_ray() -> void :
	if rays[0].enabled == true:
		rays[0].enabled = false
	else : rays[0].enabled = true

func get_pos() -> Vector3:
	return position

func get_facing() -> Vector3:
	match current_dir:
		"north": return -basis.z
		"east": return -basis.x
		"south": return basis.z
		"west": return basis.x
	return Vector3(0,0,1)

func update_facing(dir_change:int) -> void:
	var temp = facing.find(current_dir)
	#print("Mod Result: " + str(temp+dir_change)%4)
	current_dir=facing[((temp+dir_change)%4)]

func wall_bonk() -> bool:
	if rays[0].is_colliding() :
		scanning_wall = true
		return true
	else : 
		scanning_wall = false 
		return false
func advance() -> void:
	#self.set_physics_process(false)
	if !wall_bonk():
		tween_translate(get_facing())
		## TODO : Update this so that the movement is actually handled by the behavioral tree

func turn() -> int:
	var pick_direction : int = 0
	for r in rays :
		if r.is_colliding() :
			pick_direction += r.get_index()
	if pick_direction == 0 :
		return randi_range(1,3)
	return (pick_direction % rays.size())

func tween_translate(new_pos:Vector3) -> void:
	tweener = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tweener.tween_property(self,"global_transform",global_transform.translated(new_pos),.5)
	await tweener.finished

func tween_rotate(mode:int)-> void:
	if mode == 0 : return
	tweener = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	## 90 == LEFT, 180 == BACK, -90 == RIGHT
	if mode == 4:
		mode = randi_range(1,3)
	match mode:
		1: 
			var q = Quaternion(self.basis.y,deg_to_rad(90))
			tweener.tween_property(self,"quaternion",q,.5)
		2: 
			var q = Quaternion(self.basis.y,deg_to_rad(180))
			tweener.tween_property(self,"quaternion",q,.5)
		3: 
			var q = Quaternion(self.basis.y,deg_to_rad(270))
			tweener.tween_property(self,"quaternion",q,.5)
		0: return
	await tweener.finished
