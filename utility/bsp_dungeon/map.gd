class_name Map extends Node3D

@export var map : GridMap
@export var bot : PackedScene
@export var player : Player
#@export var bot : Bot

@export var map_size := Vector2i(6, 6)
var paths := []
var root_node : Branch
var tile_size : int = 3

func _ready() -> void:
	if map:
		MoveHandler.map = map
	
	map.cell_size = Vector3i(tile_size, tile_size, tile_size)
	root_node = Branch.new(Vector2i(0, 0), Vector2i(map_size.x * tile_size, map_size.y * tile_size))
	#root_node.split(3, paths)
	root_node.split(0, paths)
	generate_map()

func generate_map() -> void:
	var boss_room = _find_boss_room()
	var starter_room = _choose_starting_room()
	
	for leaf in root_node.get_leaves():
		var padding := Vector4i(
			GameGlobal.rng.randi_range(2, 3),
			GameGlobal.rng.randi_range(2, 3),
			GameGlobal.rng.randi_range(2, 3),
			GameGlobal.rng.randi_range(2, 3)
		)
		
		for x in range(leaf.size.x):
			for y in range(leaf.size.y):
				if not is_inside_padding(x, y, leaf, padding):
					map.set_cell_item(Vector3i(x + leaf.position.x, 0, y + leaf.position.y), 0)
					
					var map_pos := map.map_to_local(Vector3i(x + leaf.position.x, 0, y + leaf.position.y))
					var pos := map.to_global(map_pos)
					
					_create_collider(pos)
	
	for path in paths:
		if path['left'].y == path['right'].y:
			for i in range(path['right'].x - path['left'].x):
				_create_path_cell(path['left'], i, 5, true)
		else:
			for i in range(path['right'].y - path['left'].y):
				_create_path_cell(path['left'], i, 3)
	
	var starter_pos := starter_room.get_center()
	var map_pos := map.map_to_local(Vector3i(starter_pos.x, 0, starter_pos.y))
	var pos := map.to_global(map_pos)
	
	#player.global_position = pos + Vector3(0, 3, 0)
	#bot.global_position = pos + Vector3(0, 3, 0)
	spawn_boss(boss_room)

func is_inside_padding(x : int, y : int, leaf : Branch, padding : Vector4i) -> bool:
	return x <= padding.x or y < padding.y or x >= leaf.size.x - padding.z or y >= leaf.size.y - padding.w

func spawn_boss(b:Branch) -> void:
	var boss = bot.instantiate()
	var boss_pos := b.get_center()
	var map_pos := map.map_to_local(Vector3i(boss_pos.x, 0, boss_pos.y))
	var pos := map.to_global(map_pos)
	
	boss.global_position = pos + Vector3(0, 3, 0)
	
	add_child(boss)
	boss.add_to_group("boss")

func _find_boss_room() -> Branch:
	var largest_room : Branch
	var i : int = 0
	for leaf in root_node.get_leaves():
		if largest_room:
			var largest_room_area = largest_room.size.x * largest_room.size.y
			var leaf_room_area = leaf.size.x * leaf.size.y
			if largest_room_area < leaf_room_area:
				largest_room = leaf
		else:
			largest_room = leaf
			
	return largest_room
				

func _choose_starting_room() -> Branch:
	var boss_room = _find_boss_room()
	var choose_from = root_node.get_leaves()
	choose_from.erase(boss_room)
	
	return choose_from.get(GameGlobal.rng.randi_range(0, choose_from.size() - 1))

func _create_path_cell(pos: Vector2i, value: int = 0, path_width: int = 1, horizontal: bool = false) -> void:
	var disp : int = 0
	if path_width % 2 == 0:
		disp = path_width / 2
	else:
		disp = (path_width - 1) / 2
	
	if horizontal:
		for i in range(path_width):
			map.set_cell_item(Vector3i(pos.x + value, 0, pos.y + (i - disp)), 0)
	else:
		for i in range(path_width):
			map.set_cell_item(Vector3i(pos.x + (i - disp), 0, pos.y + value), 0)

func _create_collider(pos: Vector3) -> void:
	var collider := StaticBody3D.new()
	var shape := CollisionShape3D.new()
	shape.shape = BoxShape3D.new()
	shape.shape.size = Vector3(tile_size, tile_size, tile_size)
	map.add_child(collider)
	collider.global_position = pos + Vector3(0, tile_size / 2., 0)
	collider.add_child(shape)
