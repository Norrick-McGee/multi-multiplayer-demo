extends TileMapLayer
class_name GrassTileMap

@export var source_tilemap: TileMapLayer 
@export var offset = Vector2(8,8)

"""
Window 
  poke((5,2),"dirt") -> tiles_to_update: (4,1), (5,1), (4,2), (5,2)
  
  5,3 -> (4,2), (4,3), (5,2), (5,3)
  6,2 -> (5,1), (5,2), (6,1), (6,2)

Update_function( (4,1) ):
	#@cacheresults
	check ReactiveTileMap(4,1), (5,1), (4,2), (5,2) # bool is_dirt/grass
	returns 0101 # GrassTile 4,1 will be updated with atlas of 0101
Update_function( (4,2) ):
	check ReactiveTileMap(4,2), (5,2), (4,3), (5,3)
	return 0111
Update_function: (4,1), (5,1), (4,2), (5,2)
"""

func _ready():
	paint_from_source()
	
func paint_from_source():
	pass

func poke_all(tile_list: Array, tile_type):
	for tile in tile_list: 
		poke(tile, tile_type)

# TODO: Validate these Binary vs Atlas combos possibly modify the compution
var atlas_coord_dict = {
		'0010':Vector2i(0,0),
		'0101':Vector2i(1,0),
		'1011':Vector2i(2,0),
		'0011':Vector2i(3,0),
		
		'1001':Vector2i(0,1),
		'0111':Vector2i(1,1),
		'1111':Vector2i(2,1),
		'1110':Vector2i(3,1),
		
		'0100':Vector2i(0,2),
		'1100':Vector2i(1,2),
		'1101':Vector2i(2,2),
		'1010':Vector2i(3,2),
		
		'0000':Vector2i(0,3),
		'0001':Vector2i(1,3),
		'0110':Vector2i(2,3),
		'1000':Vector2i(3,3)
	}
	
func poke(coords: Vector2,  tile_type: String):
	var x = coords.x
	var y = coords.y
	var tiles_to_update = [
			Vector2(x-1, y-1),
			Vector2(x, y-1),
			Vector2(x-1, y),
			Vector2(x,y)
		]
		
	#   Vect2   array[vect2]
	for tile in tiles_to_update:
		#   str('0101') # binary represents False, True, False, True, of "is this corner Dirt?"
		var atlas_binary = get_atlas_binary_from_neighbors( tile, tile_type )
		
		#   Vect2i(1,2)
		var atlas_coords = atlas_coord_dict[atlas_binary]
		
		self.set_cell(tile, 0, atlas_coords) # 0 = first tileset.png on tilemap layer

		
func get_atlas_binary_from_neighbors( tile, tile_type ):
	# WARN: This function is called 4x per 1 Poke (of 1 tile)
	
	var x = tile.x 
	var y = tile.y 
	
	# Define tiles that need to be checked to build our binary blob
	var tiles_to_check = [
			Vector2(x-1, y-1),
			Vector2(x, y-1),
			Vector2(x-1, y),
			Vector2(x,y)
		]
		
	# Compose Binary String to return
	var return_binary_blob = ""
	for a in tiles_to_check:
		# WARN: this function is called 4x, and this loop happens 4x in func, this means "is_cell_type" (and str and int) are called 16x per 1 poke
		return_binary_blob = return_binary_blob+str(int(source_tilemap.is_cell_type(tile, tile_type)))
	# TODO: Debug: We are seeing 1111 for all, instead of (1101, 1110, 0100, 1000)
	print(return_binary_blob)

	return return_binary_blob
