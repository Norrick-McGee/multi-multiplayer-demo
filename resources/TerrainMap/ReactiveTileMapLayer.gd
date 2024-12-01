@tool
extends TileMapLayer
class_name ReactiveTileMapLayer

signal cells_changed(changed_cells: Array)
var previous_state: Dictionary = {}

func _physics_process(_delta):
	detect_changes(previous_state, capture_current_state())
func _ready():
	detect_changes(previous_state, capture_current_state())
	set_process(true)
	
func capture_current_state() -> Dictionary:
	# Capture the current state of all cells in the TileMapLayer
	var state = {}
	for coord in self.get_used_cells():
		state[coord] = self.get_cell_atlas_coords(coord)
	return state
	
func detect_changes(old_state: Dictionary, new_state: Dictionary) -> Array:
	var changes = []
	# Detect added or modified cells
	for coord in new_state.keys():
		if not old_state.has(coord) or old_state[coord] != new_state[coord]:
			changes.append(coord)
	# Detect removed cells
	for coord in old_state.keys():
		if not new_state.has(coord):
			changes.append(coord)
	if changes.size() > 0:
		emit_signal("cells_changed", changes)
		# Update
		previous_state = new_state
	return changes
