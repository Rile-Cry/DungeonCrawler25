extends Node

const map_bounds : Vector2i = Vector2i()
const tiles_to_load : Array[DungeonTileResource] = [
	preload("res://gameplay/resources/DungeonTiles/EmptyTile.tres")
]

var dungeon_tiles : Dictionary[Genum.DungeonTileType, Array] = {}

func _ready() -> void:
	_sort_tiles()
	generate_map()

func generate_map() -> void:
	# TODO: Replace with WFC later
	pass

func _sort_tiles() -> void:
	var id = -1
	for tile in tiles_to_load:
		match(tile.tile_type):
			Genum.DungeonTileType.EMPTY:
				id = tile.tile_type
	
		if dungeon_tiles.has(id):
			dungeon_tiles.get(id).append(tile)
		else:
			dungeon_tiles.set(id, [tile])
