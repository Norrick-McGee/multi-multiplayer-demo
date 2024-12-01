extends Node

@export var StartScreen: StartScreen

@export var DemoSelectionArray: Array[GameMode]
func get_demo_scene_from_key(key):
	var packed_scene: PackedScene
	for i in DemoSelectionArray: 
		if i.game_type == key:
			packed_scene =  i.demo_path
	return packed_scene

var eNetPeer = ENetMultiplayerPeer.new()

func _ready():
	#########
	# Initialize StartScreen 
	#########
	var demo_titles: Array[String] = []
	for GameModeResource in DemoSelectionArray:
		demo_titles.append(GameModeResource.game_type)
	StartScreen.set_game_types(demo_titles)
	StartScreen.connect("start_game", start_game)

func valid_context(game_context: Dictionary):
	return true

func start_game(game_context: Dictionary):
	"""
	args
	___
	game_context (Dictionary):
	{
		"player":{
			'name':'bubbins',
			'color': Color(255.0, 255.0, 0.0, 0.999)
		},
		"client":{
			'type':'client',
			'ipv4':'127.0.0.1',
			'port':6767
		}
		"game_type":"Topdown 2D" || "Platformer 2D" # not yet implimented
	}
	valid game_type's:
		Topdown 2D
		Platform 2D
		FPS
		Topdown 2.5D - In Progress
		Turn Based Strategy 
		Realtime Strategy
	"""
	if not valid_context(game_context): return
	
	##############
	# Networking
	##############
	
	if game_context['conn']['type'].to_lower() == 'host':
		eNetPeer.create_server(game_context['conn']['port'])
	elif game_context['conn']['type'].to_lower() == 'client':
		eNetPeer.create_client(
			game_context['conn']['ipv4'],
			game_context['conn']['port']
			)
	multiplayer.multiplayer_peer = eNetPeer
	
	##############
	# setting up the game world
	##############
	var scene_to_start: PackedScene = get_demo_scene_from_key(game_context['game_type'])
	
	# TODO: scene_to_start.start_me_up(once, you, start, me, up, I, never, stop)
	StartScreen.hide()
