extends Node2D

@export var game_map : TileMapLayer
@export var path : TileMapLayer
@export var astar_map : GridMap
@export var map : Node3D
var maps := []
var player_pos :=  Vector2i(0,0)
var nearest_bot := Vector2i(0,0)
@export var map_screen : Sprite3D

var p_to_map_local := Vector3(0,1.5,0)
var b_to_map_local := Vector3(0,1.5,0)


var astar_grid: AStarGrid2D
var start_cell: Vector2i
var end_cell: Vector2i

func _ready() -> void:
	#GameGlobalEvents.position_updated.connect(_path_to_nearest_bot)
	
	_init_grid()
	_update_grid_from_tilemap()
	call_deferred("find_path")

func get_3d_to_2d(node:Variant) -> Vector2i:
	if node == null : return Vector2i(0,0)
	elif node is Vector3i :
		return Vector2i(node.x,node.z)
	elif node is Node3D:
		return Vector2i(node.global_position.x,node.global_position.y)
	return Vector2i(0,0)

func _path_to_nearest_bot(current_pos:Vector2i) -> void:
	var new_start_cell = to_global(get_3d_to_2d(MoveHandler.map.local_to_map(Vector3i(current_pos.x,1.5,current_pos.y))))
	
	var closest_bot : Bot
	var distance := 0 as float
	
	for bot in get_tree().get_nodes_in_group(&"enemies") :
		p_to_map_local = MoveHandler.map.map_to_local(Vector3i(current_pos.x,1.5,current_pos.y))
		b_to_map_local = MoveHandler.map.map_to_local(Vector3i(bot.global_position))
		#print("P to map local %s " % p_to_map_local + "\nB to map Local %s " % b_to_map_local)
		if p_to_map_local.distance_to(b_to_map_local) > distance:
			#print("New closest bot at %s " % b_to_map_local)
			distance = p_to_map_local.distance_to(b_to_map_local)
			closest_bot = bot
			nearest_bot = Vector2(bot.position.x,bot.position.z)
		else : distance = p_to_map_local.distance_to(b_to_map_local)
	
	if closest_bot != null : 
		var new_end_cell = to_global(get_3d_to_2d(MoveHandler.map.local_to_map(Vector3i(current_pos.x,1.5,current_pos.y))))
	
		if new_start_cell != start_cell or new_end_cell != end_cell:
			find_path()


func _init_map_transfer() -> void:
	var map_array := MoveHandler.get_2d_map() as Array[Vector2i]
	for map in map_array:
		game_map.set_cell(map, 2)

# Create an AStarGrid2D instance from the size of the game map
# Note that fundamental changes like size and cell_size require
# calling update() on the grid before it is usable
func _init_grid() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = map_screen.region_rect
	astar_grid.cell_size = Vector2i(MoveHandler.map.cell_size.x,MoveHandler.map.cell_size.z)
		
	astar_grid.update()

# Look up each grid cell in our AStarGrid2D instance
# and set it to solid based on whether or not it is a wall in the game map
func _update_grid_from_tilemap() -> void:
	for i in range(astar_grid.size.x):
		for j in range(astar_grid.size.y):
			var id = MoveHandler.map.local_to_map(Vector3i(i,1.5, j))
			game_map.set_cell(Vector2i(id.x,id.z),MoveHandler.map.get_cell_item(id))
			
			## TODO : Figure Out how to get the correct set of coordinates to draw the 2d map of the world from, the 3d gridmap we have, with the correct cell data
			# If game_map does not have a cell source id >= 0
			# then we're looking at an invalid location
			match MoveHandler.map.get_cell_item(id) :
				1 :
					var tile_type = game_map.get_cell_tile_data(Vector2(id.x,id.z))
					astar_grid.set_point_solid(Vector2i(id.x,id.z),true)
				2 : 
					var tile_type = game_map.get_cell_tile_data(Vector2(id.x,id.z))
					astar_grid.set_point_solid(Vector2i(id.x,id.z),false)
				_: astar_grid.set_point_solid(Vector2i(id.x,id.z),true)
func find_path() -> void:
	path.clear()
	start_cell = game_map.local_to_map(player_pos)
	end_cell = game_map.local_to_map(nearest_bot)
	
	if start_cell == end_cell or !astar_grid.is_in_boundsv(start_cell) or !astar_grid.is_in_boundsv(end_cell):
		return

	var id_path = astar_grid.get_id_path(start_cell, end_cell)
	for id in id_path:
		path.set_cell(id,0,Vector2(0, 0))
