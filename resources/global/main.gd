extends Node

@export var StartScreen: Control
var active_scene: Node
var eNetPeer = ENetMultiplayerPeer.new()

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
	"""
	if not valid_context(game_context): return
	if game_context['client']['type'].to_lower() == 'host':
		eNetPeer.create_server(game_context['client']['port'])
	elif game_context['client']['type'].to_lower() == 'client':
		eNetPeer.create_client(
			game_context['client']['ipv4'],
			game_context['client']['port']
			)
	else: 
		"""Lets move this to func valid_context()"""
		OS.alert(
			"start_game not implimented for game_context['client']['type'] = {t}".format({'t':game_context['client']['type'].to_lower()}), 
			"Error Starting Game"
			)
		return
	multiplayer.multiplayer_peer = eNetPeer
	
	StartScreen.hide()
