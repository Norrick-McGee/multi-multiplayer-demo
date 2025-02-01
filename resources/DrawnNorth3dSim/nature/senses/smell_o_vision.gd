extends Area3D

signal smell_entered(scent: Scent3D) 
signal smell_exited(scent: Scent3D) 
@export var smell_o_vision_source: Node3D 


func _ready():
	area_entered.connect(emit_smell_signal_on_enter)
	area_exited.connect(emit_smell_signal_on_exit)
	if smell_o_vision_source == null: 
		smell_o_vision_source = get_parent()


func emit_smell_signal_on_enter(area):
	if area is Scent3D:
		if area.smell_source != self.smell_o_vision_source:
			emit_signal("smell_entered", area)

func emit_smell_signal_on_exit(area):
	if area is Scent3D:
		if area.smell_source != self.smell_o_vision_source:
			emit_signal("smell_exited", area)
