extends Node3D

@export var bot_scene : PackedScene

var player : Player
var spawn_dist : int = 24
var spawned_bots : Array[Bot] = []
var spawn_cap : int = 3
var spawn_time :=  4
var current_time := spawn_time

func _ready() -> void:
	GameGlobalEvents.game_tick.connect(_on_game_tick)
	
	player = get_tree().get_first_node_in_group(&"player")

func _on_game_tick() -> void:
	if not player:
		player = get_tree().get_first_node_in_group(&"player")
	
	if current_time == 0:
		if spawned_bots.size() != spawn_cap:
			if player:
				var player_map_pos := MoveHandler.grab_tile_position(player.global_position)
				var factory_map_pos := MoveHandler.grab_tile_position(global_position)
				if factory_map_pos.distance_to(player_map_pos) <= spawn_dist:
					var bot = bot_scene.instantiate()
					add_child(bot)
					spawned_bots.append(bot)
					bot.add_to_group(&"enemies")
		
		current_time = spawn_time
	
	current_time -= 1
