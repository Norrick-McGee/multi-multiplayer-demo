extends Node3D

enum xyz_enum { x, y, z }
enum RotationMode { FIXED, FACE_LOCKED, FREE_ROTATION }

@export var orbit_axis: xyz_enum = xyz_enum.y
@export var orbit_origin: Node3D # Reference to the singularity
@export var orbit_speed: float = 1.0 # Speed of orbiting (radians per second)
@export var self_rotation_speed: float = 1.0 # Speed of self-rotation (only for FREE_ROTATION)
@export var rotation_mode: RotationMode = RotationMode.FIXED

var current_rotation: float = 0.0

func _process(delta: float) -> void:
	if not orbit_origin:
		return
	
	# Compute the rotation angle for orbiting
	var angle = orbit_speed * delta
	
	# Determine the axis of rotation
	var rotation_axis = Vector3.ZERO
	if orbit_axis == xyz_enum.x:
		rotation_axis = Vector3.RIGHT
	elif orbit_axis == xyz_enum.y:
		rotation_axis = Vector3.UP
	elif orbit_axis == xyz_enum.z:
		rotation_axis = Vector3.FORWARD
	
	# Create a rotation quaternion for orbiting
	var rotation_quat = Quaternion(rotation_axis, angle)
	
	# Get the current position relative to the singularity
	var relative_position = global_position - orbit_origin.global_position
	
	# Apply orbit rotation to maintain distance from singularity
	relative_position = rotation_quat * relative_position
	global_position = orbit_origin.global_position + relative_position

	# Handle different rotation modes
	match rotation_mode:
		RotationMode.FACE_LOCKED:
			look_at(orbit_origin.global_position, Vector3.UP) # Always face the singularity
		
		RotationMode.FREE_ROTATION:
			# Add self-rotation on the local Y-axis
			current_rotation += self_rotation_speed * delta
			rotate(Vector3.UP, self_rotation_speed * delta)
		
		RotationMode.FIXED:
			pass  # No additional rotation
