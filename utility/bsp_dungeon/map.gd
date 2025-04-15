extends Node3D

@export var camera : Camera3D
@export var map : GridMap

var paths := []
var root_node : Branch
var tile_size : int = 5

func _ready() -> void:
	root_node = Branch.new(Vector2i(0, 0), Vector2i(120, 120))
	root_node.split(3, paths)
	generate_map()

func generate_map() -> void:
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
	
	for path in paths:
		if path['left'].y == path['right'].y:
			for i in range(path['right'].x - path['left'].x):
				_create_path_cell(path['left'], i, 5, true)
				#map.set_cell_item(Vector3i(path['left'].x + i, 0, path['left'].y - 1), 0)
				#map.set_cell_item(Vector3i(path['left'].x + i, 0, path['left'].y), 0)
				#map.set_cell_item(Vector3i(path['left'].x + i, 0, path['left'].y + 1), 0)
		else:
			for i in range(path['right'].y - path['left'].y):
				_create_path_cell(path['left'], i, 3)
				#map.set_cell_item(Vector3i(path['left'].x - 1, 0, path['left'].y + i), 0)
				#map.set_cell_item(Vector3i(path['left'].x, 0, path['left'].y + i), 0)
				#map.set_cell_item(Vector3i(path['left'].x + 1, 0, path['left'].y + i), 0)

func is_inside_padding(x : int, y : int, leaf : Branch, padding : Vector4i) -> bool:
	return x <= padding.x or y < padding.y or x >= leaf.size.x - padding.z or y >= leaf.size.y - padding.w

func find_boss_room() -> Branch:
	var largest_room : Branch
	for leaf in root_node.get_leaves():
		if largest_room:
			var largest_room_area = largest_room.size.x * largest_room.size.y
			var leaf_room_area = leaf.size.x * leaf.size.y
			if largest_room_area < leaf_room_area:
				largest_room = leaf
		else:
			largest_room = leaf
	
	return largest_room
				

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
