extends MeshInstance3D
@export var color_picker: ColorPickerButton

func _process(delta):
	self.get_surface_override_material(0).albedo_color = color_picker.color
