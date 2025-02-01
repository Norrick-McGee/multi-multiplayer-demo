extends Node3D

enum xyz_enum { x, y, z }
enum RotationMode { FIXED, FACE_LOCKED, FREE_ROTATION }

@export var orbit_axis: xyz_enum = xyz_enum.y
@export var orbit_origin: Node3D # Reference to the singularity
@export var orbit_speed: float = 1.0 # Speed of orbiting (radians per second)
@export var self_rotation_speed: float = 1.0 # Speed of self-rotation (only for FREE_ROTATION)
@export var rotation_mode: RotationMode = RotationMode.FIXED
@export var world_scene: PackedScene # The scene to load inside the dimension simulation
@export var strength: float = 0.5 # Shader strength


var current_rotation: float = 0.0
var subviewport: SubViewport
var world_3d: World3D

var shader_material: ShaderMaterial

func _ready() -> void:
	# Get the SubViewport and set up the World3D
	subviewport = $SubViewport

	# Load the world scene into the dimension's World3D
	var world_instance = world_scene.instantiate()
	subviewport.add_child(world_instance)

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

@onready var mesh_instance = $MeshInstance3D
@onready var sub_viewport = $SubViewport
func _physics_process(delta):
	# Get the texture from SubViewport
	var viewport_texture = sub_viewport.get_texture()
	
	# Apply the texture to the MeshInstance3D's material
	var material = StandardMaterial3D.new()
	material.albedo_texture = viewport_texture
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED  # Avoid lighting issues
	mesh_instance.set_surface_override_material(0, material)
