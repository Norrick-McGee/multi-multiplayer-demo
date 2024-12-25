extends Node

@onready var StartScreen: StartScreen = $StartScreen
@onready var NetMan: NetMan = $NetMan
@export var DemoSelectionArray: Array[GameMode]

func get_demo_scene_from_key(key):
	var packed_scene: PackedScene
	for i in DemoSelectionArray: 
		if i.game_type == key:
			packed_scene = i.demo_path
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

func is_2d(scene):
	pass
	
func is_3d(scene):
	pass

func start_game(game_context: Dictionary):
	"""
	args
	___
	game_context (Dictionary):
	{
		"player":{
			'name':'bubbins', 'color': Color(255.0, 255.0, 0.0, 0.999) # not yet implimented
		},
		"client":{
			'type':'client', 'ipv4':'127.0.0.1', 'port':6767
		}
		"game_type":"Topdown 2D" || "Platformer 2D" # not yet implimented
	}
	"""
	if not valid_context(game_context): return
	
	##############
	# Networking
	##############
	NetMan.conn_init(game_context['conn'])

	
	##############
	# game world
	##############
	
	# Init
	var new_scene = get_demo_scene_from_key(game_context['game_type']).instantiate()
	add_child(new_scene)
	# TODO: Adjust properties
	if new_scene is Node2D:
		print("This is a 2D node.")
		new_scene.position = Vector2(0, 0) 
	elif new_scene is Node3D:
		print("This is a 3D node.")
	else:
		print("This is neither a 2D nor a 3D node.")
	
	
	# Hide StartScreen 
	StartScreen.hide()
	StartScreen.queue_free()
