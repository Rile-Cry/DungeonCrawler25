class_name Branch extends Node

var left_child : Branch
var right_child : Branch
var position : Vector2i
var size : Vector2i

func _init(pos: Vector2i, siz: Vector2i) -> void:
	self.position = pos
	self.size = siz

func get_center() -> Vector2i:
	return Vector2i(position.x + size.x / 2, position.y + size.y / 2)

func get_leaves() -> Array[Branch]:
	if not (left_child && right_child):
		return [self]
	else:
		return left_child.get_leaves() + right_child.get_leaves()

func split(remaining : int, paths: Array) -> void:
	var split_percent := GameGlobal.rng.randf_range(0.3, 0.7)
	var split_horizontal := size.y >= size.x
	
	if split_horizontal:
		var left_height = int(size.y * split_percent)
		left_child = Branch.new(position, Vector2i(size.x, left_height))
		right_child = Branch.new(
			Vector2i(position.x, position.y + left_height),
			Vector2i(size.x, size.y - left_height)
		)
	else:
		var left_width = int(size.x * split_percent)
		left_child = Branch.new(position, Vector2i(left_width, size.y))
		right_child = Branch.new(
			Vector2i(position.x + left_width, position.y),
			Vector2i(size.x - left_width, size.y)
		)
	
	if remaining > 0:
		left_child.split(remaining - 1, paths)
		right_child.split(remaining - 1, paths)
	
	paths.push_back({'left': left_child.get_center(), 'right': right_child.get_center()})
