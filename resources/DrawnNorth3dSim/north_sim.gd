extends Node3D

@export var focus: CharacterBody3D
func clear_focus():
	focus = null
func set_focus(character: CharacterBody3D):
	focus = character
