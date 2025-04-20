class_name Bot extends CharacterBody3D

@export var ray_box:Node3D
var rays : Array[RayCast3D]
@onready var tweener:Tween
var directions : Dictionary = {0:Vector3i.FORWARD,1:Vector3i.RIGHT,2:Vector3i.BACK, 3:Vector3i.LEFT}
var dir:Vector3
var target_dir:Vector3

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

func update_facing(to_face:int) -> void:
	dir = directions[to_face]

#func drop_in() -> void:
	#var landing = global_position - Vector3(0,100,0)
	#tweener= get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	#tweener.tween_property(self,"global_position",landing,3)

func wall_bonk() -> bool:
	if rays[0].is_colliding() :
		return true
	else : 
		return false

func path_search() -> Array[int] :
	var temp : Array[int]
	for r in rays :
		if !r.is_colliding():
			temp.append(r.get_index())
	#print(temp)
	#print("Above is results of PATH SEARCH")
	return temp

func move_bot(pick:int) -> void:
	update_facing(pick)	
	if pick == 0:
		MoveHandler.move_body(self)
		if target_dir == global_position : return
		tween_translate(pick)
	else:
		tween_rotate(pick)
		MoveHandler.move_body(self)

func tween_translate(facing:int) -> void:
	tweener = get_tree().create_tween().bind_node(self)
	#var temp = [global_position,target_dir, directions[facing]]
	#print("Current Pos: %s  Target Pos: %s  Direction Facing: %s" % temp)
	tweener.tween_property(self,"global_position",target_dir,1.5)
	await tweener.finished

func tween_rotate(mode:int)-> void:
	if mode == 0 : return
	tweener = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	## -90 == RIGHT, 180 == BACK, 90 == LEFT
	if mode == 4:
		mode = randi_range(1,3)
	match mode:
		1: 
			tweener.tween_property(self, "rotation_degrees",rotation_degrees + Vector3(0, -90, 0), 1.5)
		2: 
			tweener.tween_property(self, "rotation_degrees",rotation_degrees + Vector3(0, 180, 0), 1.5)
		3: 
			tweener.tween_property(self, "rotation_degrees",rotation_degrees + Vector3(0, 90, 0), 1.5)
		0: return
	await tweener.finished
