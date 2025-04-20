extends Node

signal pause_game
signal resume_game
signal register_to_map(body: Node3D)
signal game_tick

signal get_target_pos(cur_pos: Vector3, dir: Vector3)
signal receive_target_pos(new_pos: Vector3)
signal position_updated(pos:Vector2i)
