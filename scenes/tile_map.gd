extends TileMapLayer


func get_line(start: Vector2i, end: Vector2i) -> Array:
	var points = []
	
	var delta = end - start
	var n = max(abs(delta.x), abs(delta.y))
	
	for step in range(n):
		var t = step / n
		var lerp_point = Vector2(start).lerp(Vector2(end), t)
		var rounded_point = lerp_point.floor()
		points.append(rounded_point)

	points.append(end)
	return points
