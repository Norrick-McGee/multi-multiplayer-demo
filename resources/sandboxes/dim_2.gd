extends Node3D

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
