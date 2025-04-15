extends Node

signal pause_game
signal resume_game
signal game_tick

signal get_target_pos(cur_pos: Vector3, dir: Vector3)
signal receive_target_pos(new_pos: Vector3)
