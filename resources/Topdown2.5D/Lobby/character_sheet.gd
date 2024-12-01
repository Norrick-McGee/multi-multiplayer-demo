@tool
extends PanelContainer

@export var label_text: String:
	set(value):
		$CharacterSheet/Label.text = value
	get():
		return $CharacterSheet/Label.text
