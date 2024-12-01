@tool
extends ReactiveTileMapLayer

@export var GrassTileMapLayer: TileMapLayer
@export var DirtTileMapLayer: TileMapLayer
@export var WaterTileMapLayer: TileMapLayer
@export var SnowTileMapLayer: TileMapLayer
@export var LavaTileMapLayer: TileMapLayer

func _ready():
	connect("cells_changed",_on_cells_changed)
	super._ready()
	
func _physics_process(delta):
	super._physics_process(delta)

func _on_cells_changed(changed_cells: Array):
	for coords in changed_cells: 
		for type in ['grass', 'dirt', 'water', 'snow', 'lava']:
			paint_cells_related_to(coords, type)

var cell_type_dict = {
	"grass":{"atlas_coords":Vector2i(0,0), "tilemap":GrassTileMapLayer},
	"dirt":{"atlas_coords":Vector2i(1,0), "tilemap":DirtTileMapLayer},
	"water":{"atlas_coords":Vector2i(2,0), "tilemap":WaterTileMapLayer},
	"snow":{"atlas_coords":Vector2i(3,0), "tilemap":SnowTileMapLayer},
	"lava":{"atlas_coords":Vector2i(4,0), "tilemap":LavaTileMapLayer},
}

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
	

var offsets_3x3 = [
	Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
	Vector2i(-1,  0), Vector2i(0,  0), Vector2i(1,  0),
	Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1)
]

var offsets_2x2 = [
	Vector2i(0, 0), Vector2i(1, 0),
	Vector2i(0, 1), Vector2i(1, 1)
]

var to_paint_offset = [
	Vector2i(-1, -1), Vector2i(0, -1),
	Vector2i(-1,  0), Vector2i(0,  0)
]

func paint_cells_related_to(coords, type):
	# Looks good, if statement for determing TileMapLayer is kinda ugly tho
	
	#                        Consider moving this out of the function. 
	var atlas_binaries_2x2 = tiletype_convolution_2x2(coords, type)
	var tilemap: TileMapLayer
	if type == 'grass': 
		tilemap = GrassTileMapLayer
	if type == 'dirt':
		tilemap = DirtTileMapLayer
	if type == 'water':
		tilemap = WaterTileMapLayer
	if type == 'snow':
		tilemap = SnowTileMapLayer
	if type == 'lava':
		tilemap = LavaTileMapLayer

	tilemap.set_cell(coords + to_paint_offset[0], 0, atlas_coord_dict[atlas_binaries_2x2[0][0]])
	tilemap.set_cell(coords + to_paint_offset[1], 0, atlas_coord_dict[atlas_binaries_2x2[0][1]])
	tilemap.set_cell(coords + to_paint_offset[2], 0, atlas_coord_dict[atlas_binaries_2x2[1][0]])
	tilemap.set_cell(coords + to_paint_offset[3], 0, atlas_coord_dict[atlas_binaries_2x2[1][1]])
	
	
func is_tile_type(tile, type_to_check: String):
	return self.get_cell_atlas_coords(tile) == cell_type_dict[type_to_check]["atlas_coords"]
	
func tiletype_convolution_2x2(coordinate: Vector2i, tile_type: String) -> Array:
	#// This return 2x2 chunk is a binary representaiton of the 4 Paint Cells that are changed by the 1 cell (coordinate) being changed. The 2x2 is calculated from the 3x3 terrain-square surrounding the original coord
	#/// a 1D array, which represents a 3x3 matrix of True/False values (represented by 1,0 instead of bool)
	var terrain_bool_window = []
	for offset in offsets_3x3:
		var check_pos = coordinate + offset
		terrain_bool_window.append(int(is_tile_type(check_pos, tile_type)))
	
	# Consider flattening output. Would need to tweak paint_cells_related_to(): atlas_binaries_2x2[0][0] -> atlas_binaries_2x2[0]
	var discrete_binary_convolution = []
	for y in [0,1]:
		var row = []
		for x in [0,1]:
			var binary_result = ""
			for sub_offset in offsets_2x2:
				var nx = x + int(sub_offset.x)
				var ny = y + int(sub_offset.y)
				var index = ny * 3 + nx #// Convert (x, y) into a linear index for binary_window (Linear Indexing is so we can treat our 1D array like a 3x3 matrix)
				binary_result += str(terrain_bool_window[index])
			row.append(binary_result)
		discrete_binary_convolution.append(row)

	return discrete_binary_convolution


"""
TODO:
	Garbage Collection? Our Draw Layers draw a lot of empty spaces, when we delete/overwrite tiles. 
	Consider adding something to account for that. 
	
	Let's try to make the Different Tiletype stuff be a little less hard coded
"""
