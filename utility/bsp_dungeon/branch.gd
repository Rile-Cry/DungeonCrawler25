class_name Branch extends Node

var left_child : Branch
var right_child : Branch
var is_boss : bool = false
var min_room_size : int = 9
var min_boss_room_size : int = 18
var position : Vector2i
var size : Vector2i
var tile_size : int

func _init(pos: Vector2i, siz: Vector2i, t_size: int) -> void:
	self.position = pos
	self.size = siz
	self.tile_size = t_size

func get_center() -> Vector2i:
	return Vector2i(position.x + size.x / 2, position.y + size.y / 2)

func get_leaves() -> Array[Branch]:
	if not (left_child && right_child):
		return [self]
	else:
		return left_child.get_leaves() + right_child.get_leaves()

func split(paths: Array) -> void:
	var split_vertical : bool = size.x > size.y
	
	if is_boss:
		boss_split(paths, split_vertical)
	else:
		normal_split(paths, split_vertical)
		
	if left_child and right_child:
		paths.push_back({'left': left_child.get_center(), 'right': right_child.get_center()})

func normal_split(paths: Array, split_v: bool) -> void:
	if (size.x > (min_room_size * 2)) or (size.y > (min_room_size * 2)):
		if split_v:
			var split_x = GameGlobal.rng.randi_range(min_room_size, size.x - min_room_size) 
			left_child = Branch.new(position, Vector2i(split_x, size.y), tile_size)
			right_child = Branch.new(
				Vector2i(position.x + split_x, position.y),
				Vector2i(size.x - split_x, size.y),
				tile_size
			)
		else:
			var split_y = GameGlobal.rng.randi_range(min_room_size, size.y - min_room_size)
			left_child = Branch.new(position, Vector2i(size.x, split_y), tile_size)
			right_child = Branch.new(
				Vector2i(position.x, position.y + split_y),
				Vector2i(size.x, size.y - split_y),
				tile_size
			)
		
		left_child.split(paths)
		right_child.split(paths)

func boss_split(paths: Array, split_v: bool) -> void:
	if (size.x > (min_boss_room_size * 2)) or (size.y > (min_boss_room_size * 2)):
		if split_v:
			var split_x = GameGlobal.rng.randi_range(min_room_size, size.x - min_room_size)
			left_child = Branch.new(position, Vector2i(split_x, size.y), tile_size)
			right_child = Branch.new(
				Vector2i(position.x + split_x, position.y),
				Vector2i(size.x - split_x, size.y),
				tile_size
			)
		else:
			var split_y = GameGlobal.rng.randi_range(min_room_size, size.y - min_room_size)
			left_child = Branch.new(position, Vector2i(size.x, split_y), tile_size)
			right_child = Branch.new(
				Vector2i(position.x, position.y + split_y),
				Vector2i(size.x, size.y - split_y),
				tile_size
			)
		
		if GameGlobal.rng.randi_range(0, 1) == 0:
			left_child.is_boss = true
		else:
			right_child.is_boss = true
		
		left_child.split(paths)
		right_child.split(paths)
	else:
		left_child = Branch.new(position, Vector2i(min_boss_room_size, min_boss_room_size), tile_size)
		right_child = Branch.new(position + Vector2i(min_boss_room_size, min_boss_room_size),
		Vector2i(size.x - min_boss_room_size, size.y - min_boss_room_size), tile_size)
		
		left_child.is_boss = true
		right_child.is_boss = true
