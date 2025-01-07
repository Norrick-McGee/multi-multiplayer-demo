extends Area3D

signal smell_entered
signal smell_exited

func _ready():
	area_entered.connect(emit_smell_signal_on_enter)
	area_exited.connect(emit_smell_signal_on_exit)

func emit_smell_signal_on_enter(area):
	if area is Scent3D:
		emit_signal("smell_entered")
		print("new smell!!")

func emit_smell_signal_on_exit(area):
	if area is Scent3D:
		emit_signal("smell_exited")
		print("lost smell :(")
