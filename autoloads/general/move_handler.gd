extends Node

var map : GridMap

func move_body(body: Node3D) -> void:
	var rot := body.rotation.y
	var new_dir = body.dir.rotated(Vector3(0, 1, 0), rot)
	var map_pos = grab_tile_position(body.global_position)
	map_pos += Vector3i(new_dir)
	if "target_dir" in body:
		if map.get_cell_item(map_pos) == 0:
			var offset : int = .5 if (int(map.cell_size.x) % 2 == 1) else 0
			body.target_dir = grab_tile_global_position(map_pos) + Vector3(offset, 0, offset)
			GameGlobalEvents.position_updated.emit(Vector2i(body.target_dir.x,body.target_dir.z))
		else:
			body.target_dir = body.global_position
	else:
		push_warning("There is no variable 'target_dir' in " + body.name)

func grab_tile_data_global(g_pos: Vector3) -> int:
	var map_pos := grab_tile_position(g_pos)
	return map.get_cell_item(map_pos)

func grab_tile_position(g_pos: Vector3) -> Vector3i:
	var l_pos := map.to_local(g_pos)
	return map.local_to_map(l_pos)

func grab_tile_global_position(t_pos: Vector3i) -> Vector3:
	var l_pos := map.map_to_local(t_pos)
	return map.to_global(l_pos)

func get_2d_map() -> Array[Vector2i]:
	var temp : Array[Vector2i] 
	for cell in MoveHandler.map.get_used_cells():
		temp.append(Vector2i(cell.x,cell.z))
	return temp
