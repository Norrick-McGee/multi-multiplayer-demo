extends TileMapLayer

@export var LocationMap: TileMapLayer

func print_tilemap_info():
	"""
	TODO: 
		we need to loop through all the "Active Cells" in self (self==TileMapLayer)
		Let's print out What # in TileSet each Cell is, and then we can corespond
		that with the LocationMap, so we can figure out how to calculate From LocationMap to DrawingMap
	"""
	var array = self.get_used_cells()
	array.sort()
	
	var nested_coordinates = []
	for i in range(8):
		var row = []  # Initialize an empty list for each row
		for j in range(7):  # For each column (j) from 0 to 6
			row.append(Vector2(i, j ))
			nested_coordinates.append(row)  # Add the row to the nested list
	
	print(nested_coordinates)
	
	#for coords in array:
		#print(coords)
		#print(get_cell_atlas_coords(coords))
	
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		print_tilemap_info()
