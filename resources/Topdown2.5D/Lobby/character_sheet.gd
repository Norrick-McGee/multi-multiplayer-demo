@tool
extends PanelContainer
@export var active: bool = true

@export var label_text: String =  "Player1":
	set(value):
		TitleLabel.text = value
	get():
		return TitleLabel.text

@export var TitleLabel: Label
