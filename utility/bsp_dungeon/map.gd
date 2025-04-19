class_name Map extends Node3D

@export var map : GridMap
@export var floor_map : GridMap
@export var bot : PackedScene
@export var player : Player
var boss_loc : Branch

@export var bot_factory_scene : PackedScene
@export var bot_collection : Node3D

#@export var bot : Bot

var depth : int = 6
var map_size := Vector2i(64, 64)
var paths := []
var rooms : Array[Genum.DungeonRoomType]
var root_node : Branch
var tile_size : int = 3
var current_room : Branch

var two_d_map : Array[Vector2i]

func _ready() -> void:
	if map:
		MoveHandler.map = map
	
	if player:
		player.gun_ray.target_position *= tile_size
	
	map.cell_size = Vector3i(tile_size, tile_size, tile_size)
	floor_map.cell_size = map.cell_size
	root_node = Branch.new(Vector2i(0, 0), Vector2i(map_size.x * tile_size, map_size.y * tile_size ))

	root_node.split(depth, paths)
	generate_map()
	_fill_wall()
	spawn_boss(boss_loc)
	#var loop = 0
	#while loop < 15:
		#spawn_boss(boss_loc)
		#loop +=1

func generate_map() -> void:
	var boss_room = _find_boss_room()
	boss_loc = boss_room
	var starter_room = _choose_starting_room()
	
	for leaf in root_node.get_leaves():
		var padding := Vector4i(
			GameGlobal.rng.randi_range(2, 3),
			GameGlobal.rng.randi_range(2, 3),
			GameGlobal.rng.randi_range(2, 3),
			GameGlobal.rng.randi_range(2, 3)
		)
		
		if leaf == boss_room:
			rooms.append(Genum.DungeonRoomType.BOSS)
		elif leaf == starter_room:
			rooms.append(Genum.DungeonRoomType.STARTING)
		else:
			var weight_table : Array[float] = [0.05, .95]
			var result : int = GameGlobal.rng.rand_weighted(weight_table)
			var room_types : Array[Genum.DungeonRoomType] = [
				Genum.DungeonRoomType.SAFE,
				Genum.DungeonRoomType.ENEMY
			]
			rooms.append(room_types[result])
			
			if room_types[result] == Genum.DungeonRoomType.ENEMY:
				var rand_x = GameGlobal.rng.randi_range(padding.x, leaf.size.x - padding.z) + leaf.position.x
				var rand_y = GameGlobal.rng.randi_range(padding.y, leaf.size.y - padding.w) + leaf.position.y
				var bot_factory : Node3D = bot_factory_scene.instantiate()
				bot_collection.add_child(bot_factory)
				bot_factory.position = MoveHandler.grab_tile_global_position(Vector3i(rand_x, 0, rand_y))
		
		for x in range(leaf.size.x):
			for y in range(leaf.size.y):
				if not is_inside_padding(x, y, leaf, padding):
					map.set_cell_item(Vector3i(x + leaf.position.x, 0, y + leaf.position.y), 0)

					two_d_map.append(Vector2i(x,y))

				else:
					floor_map.set_cell_item(Vector3i(x + leaf.position.x, 0, y + leaf.position.y), 0)

	
	for path in paths:
		if path['left'].y == path['right'].y:
			for i in range(path['right'].x - path['left'].x):
				_create_path_cell(path['left'], i, 1, true)
		else:
			for i in range(path['right'].y - path['left'].y):
				_create_path_cell(path['left'], i, 1)
	
	var starter_pos := starter_room.get_center()
	var map_pos := map.map_to_local(Vector3i(starter_pos.x, 0, starter_pos.y))
	var pos := map.to_global(map_pos)
	
	player.global_position = pos
	
func is_inside_padding(x : int, y : int, leaf : Branch, padding : Vector4i) -> bool:
	return x <= padding.x or y < padding.y or x >= leaf.size.x - padding.z or y >= leaf.size.y - padding.w

func spawn_boss(b:Branch) -> void:
	var boss = bot.instantiate()
	var boss_pos := b.get_center()
	var map_pos := map.map_to_local(Vector3i(boss_pos.x, 0, boss_pos.y))
	var pos := map.to_global(map_pos)
	
	boss.global_position = pos + Vector3(0,100,0)
	
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

func _fill_wall() -> void:
	for x in range(map_size.x * tile_size + 1):
		for y in range(map_size.x * tile_size + 1):
			var map_pos := Vector3i(x, 0, y)
			if map.get_cell_item(Vector3i(x, 0, y)) == -1:
				_place_wall(map_pos)

func _place_wall(pos: Vector3i) -> void:
	var checked = false
	var check_spots : Array[Vector3i] = [
		Vector3i(pos.x - 1, pos.y, pos.z),
		Vector3i(pos.x, pos.y, pos.z - 1),
		Vector3i(pos.x + 1, pos.y, pos.z),
		Vector3i(pos.x, pos.y, pos.z + 1)
	]
	
	for spot in check_spots:
		if map.get_cell_item(spot) == 0:
			checked = true
	
	if checked:
		map.set_cell_item(pos, 1)

func _check_current_room() -> void:
	pass
