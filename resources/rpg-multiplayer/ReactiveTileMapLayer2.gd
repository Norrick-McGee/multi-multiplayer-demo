extends TileMapLayer

# Signal emitted whenever the tilemap or dictionary changes
signal tilemap_changed(position: Vector2i, action: String)

# Dictionary to store tile data
var tile_data: Dictionary = {}
# Example mapping of tile types to atlas coordinates
const TILE_TYPE_TO_ATLAS_COORDS: Dictionary = {
	"dirt": Vector2i(0, 0),
	"grass": Vector2i(1, 0),
	"water": Vector2i(2, 0)
}

# Updates the dictionary and paints the corresponding tile
func set_tile_data(position: Vector2i, tile_type: String):
	# Ensure the tile type exists in the mapping
	if not TILE_TYPE_TO_ATLAS_COORDS.has(tile_type):
		push_error("Invalid tile type: %s" % tile_type)
		return

	# Update dictionary
	tile_data[position] = {"type": tile_type}

	# Paint the tile
	var atlas_coords = TILE_TYPE_TO_ATLAS_COORDS[tile_type]
	set_cell(position, atlas_coords)

	# Emit signal
	emit_signal("tilemap_changed", position, "set")

# Removes a tile from the dictionary and the TileMapLayer
func remove_tile_data(position: Vector2i):
	# Remove from dictionary
	tile_data.erase(position)

	# Erase the tile visually
	set_cell(position, Vector2i(-1, -1))

	# Emit signal
	emit_signal("tilemap_changed", position, "removed")

# Synchronizes the dictionary with the TileMapLayer
func paint_from_dictionary():
	for position in tile_data.keys():
		var tile_type = tile_data[position]["type"]
		if TILE_TYPE_TO_ATLAS_COORDS.has(tile_type):
			var atlas_coords = TILE_TYPE_TO_ATLAS_COORDS[tile_type]
			set_cell(position, atlas_coords)

# Handles painting a tile on the TileMapLayer and updating the dictionary
func _on_paint_tile(position: Vector2i, atlas_coords: Vector2i):
	# Reverse lookup atlas coordinates to find the tile type
	#for type, coords in TILE_TYPE_TO_ATLAS_COORDS.items():
		#if coords == atlas_coords:
			#set_tile_data(position, type)
			#return
#
	#push_error("No matching tile type found for atlas coordinates: %s" % atlas_coords)
	pass

# Synchronizes the dictionary when a cell is removed from the TileMapLayer
func _on_erase_tile(position: Vector2i):
	remove_tile_data(position)

# Signals for user interaction (optional)
func _input_event(event):
	if event.is_action_pressed("ui_click"):
		var click_pos = get_local_mouse_position().floor()
		var cell_pos = world_to_map(click_pos)

		# Example of erasing on right-click
		if event.button_index == BUTTON_RIGHT:
			_on_erase_tile(cell_pos)
		# Example of painting on left-click
		elif event.button_index == BUTTON_LEFT:
			_on_paint_tile(cell_pos, Vector2i(0, 0))  # Example: dirt tile

# Debugging: Prints the tile data
func debug_print_tile_data():
	print_debug(tile_data)
