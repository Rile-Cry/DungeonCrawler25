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
				map.set_cell_item(Vector3i(path['left'].x + i, 0, path['left'].y - 1), 0)
				map.set_cell_item(Vector3i(path['left'].x + i, 0, path['left'].y), 0)
				map.set_cell_item(Vector3i(path['left'].x + i, 0, path['left'].y + 1), 0)
		else:
			for i in range(path['right'].y - path['left'].y):
				map.set_cell_item(Vector3i(path['left'].x - 1, 0, path['left'].y + i), 0)
				map.set_cell_item(Vector3i(path['left'].x, 0, path['left'].y + i), 0)
				map.set_cell_item(Vector3i(path['left'].x + 1, 0, path['left'].y + i), 0)

func is_inside_padding(x : int, y : int, leaf : Branch, padding : Vector4i) -> bool:
	return x <= padding.x or y < padding.y or x >= leaf.size.x - padding.z or y >= leaf.size.y - padding.w
