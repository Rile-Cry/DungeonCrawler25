class_name Bot extends CharacterBody3D

@export var ray_box:Node3D
var rays : Array[RayCast3D]
@onready var tweener:Tween
var facing : Array[int] = [0,1,2,3]
var current_dir:int = 0

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

func get_facing() -> Vector3i:
	match current_dir:
		0: return -basis.z as Vector3i		# North
		1: return -basis.x as Vector3i		# East
		2: return basis.z as Vector3i		# South
		3: return basis.x as Vector3i		# West
	return -basis.z as Vector3i

func update_facing(dir_change:int) -> void:
	var temp = rays.find(current_dir)
	temp += dir_change
	current_dir = temp%rays.size()
	print("Current dir: " + str(current_dir))
	print("Mod Result: " + str(temp+dir_change)%4)
	
func wall_bonk() -> bool:
	if rays[0].is_colliding() :
		return true
	else : 
		return false

func advance() -> void:
	#self.set_physics_process(false)
	if !wall_bonk():
		tween_translate(get_facing())
		## TODO : Update this so that the movement is actually handled by the behavioral tree

func path_search() -> Array[int] :
	var temp : Array[int]
	for r in rays :
		if !r.is_colliding():
			temp.append(r.get_index())
	
	print(temp)
	print("Above is results of PATH SEARCH")
	return temp


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
			tweener.tween_property(self,"rotation_degrees:y",self.rotation_degrees.y+90,.5)
			current_dir+=mode%4
		2: 
			tweener.tween_property(self,"rotation_degrees:y",self.rotation_degrees.y+180,.5)
			current_dir+=mode%4
		3: 
			tweener.tween_property(self,"rotation_degrees:y",self.rotation_degrees.y-90,.5)
			current_dir+=mode%4
		0: return
	await tweener.finished
