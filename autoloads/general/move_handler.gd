extends Node

var map : GridMap
var player : Player

func move_player() -> void:
	var rot := player.rotation.y
	var new_dir = player.dir.rotated(Vector3(0, 1, 0), rot)
	var map_pos := map.local_to_map(map.to_local(player.global_position))
	map_pos += Vector3i(new_dir)
	if map.get_cell_item(map_pos + Vector3i(0, -1, 0)) > -1:
		player.target_dir = map.to_global(map.map_to_local(map_pos))
	else:
		player.target_dir = player.global_position
