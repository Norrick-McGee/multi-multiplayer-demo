@tool
extends PanelContainer

@export var label: String = "Player1"

func _ready():
	$CharacterSheet/Label.text = label
