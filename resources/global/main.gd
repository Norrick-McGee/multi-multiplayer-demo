extends Node

@export var TopDown2D: PackedScene
@export var Platform2D: PackedScene
@export var StartScreen: Control
var active_scene: Node

func start_game(client_type:String, player_attributes:Dictionary):
	active_scene = TopDown2D.instantiate()
	self.add_child(active_scene)
	StartScreen.hide()
	multiplayer.peer_connected.connect(active_scene.add_player)
	if client_type == 'host':
		active_scene.add_player(0)
