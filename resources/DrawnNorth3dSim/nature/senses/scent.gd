extends Area3D
class_name Scent3D
@export var smell_id: int = ResourceUID.create_id()
@export var smell_source: Node3D

func _ready():
	if smell_source == null: 
		smell_source = get_parent()

func _process(delta):
	pass
