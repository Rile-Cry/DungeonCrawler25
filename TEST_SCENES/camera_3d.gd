extends Camera3D


@export var bot: CharacterBody3D
@export var facing: RichTextLabel
@export var current_dir : RichTextLabel
@export var bot_rotation : RichTextLabel
@export var bot_g_rotation : RichTextLabel
@export var bot_l_rotation : RichTextLabel
@export var sub_v_port : SubViewport
var stored_y = Vector3(0,10,0)

var map_left_bottom : Vector2i
var map_top_right : Vector2i
var map_layer = MoveHandler.get_2d_map()
var pathfind_map := AStarGrid2D.new()
var visual_path_line = Line2D.new()
var path_to_player := []
var turn_counter:=1

func _ready() -> void:
	map_left_bottom = Vector2i(0,0)
	map_top_right = Vector2i(300,300)
	map_layer = MoveHandler.get_2d_map()
	add_child(visual_path_line)
	visual_path_line.add_to_group("pathline")
	pathfind_map.region = Rect2i(map_left_bottom,Vector2i(map_top_right))
	pathfind_map.cell_size = Vector2(MoveHandler.map.cell_size.x,MoveHandler.map.cell_size.z)
	pathfind_map.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	pathfind_map.update()

	for cell in MoveHandler.map.get_used_cells():
		pathfind_map.set_point_solid(Vector2i(cell.x,cell.z), true)
	
	#draw_grids()
	

func _process(delta: float) -> void:
	look_at(bot.global_position,Vector3.UP)
	facing.text = "Bot Facing: " + str(self.position.distance_to(bot.position))
	current_dir.text = "Current Dir: " + str(bot.target_dir)
	bot_rotation.text = "Bot Rotation: " + str(bot.rotation)
	bot_g_rotation.text = "Bot Global Rotation: " + str(bot.global_rotation)
	bot_l_rotation.text = "Bot Local Rotation: " + str(bot.to_local(rotation))
	
func draw_grids() -> void:
	for cell in map_layer:
		var brick = Sprite2D.new()
		brick.texture = preload("res://assets/tiles/textures/Material_004_albedo.png")
		brick.position = Vector2i(cell.x,cell.y)
		add_child.call_deferred(brick)
		add_to_group("grid_map")
		
	
func _draw_path(player:Player) -> void:
	path_to_player = pathfind_map.get_point_path(Vector2i(bot.global_position.x,bot.global_position.z)/3,Vector2i(player.global_position.x,player.global_position.z)/3)
	visual_path_line.points = path_to_player
	
	if turn_counter != 2: turn_counter +=1
	else :
		if path_to_player.size() > 1 :
			path_to_player.pop_front()
			var go_to_pos:Vector2 = path_to_player[0] + Vector2(3/2,3/2)
			
		
		visual_path_line = path_to_player
