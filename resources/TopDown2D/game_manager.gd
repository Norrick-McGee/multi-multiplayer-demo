extends Node2D
const SPAWN_POS2 = Vector2(250,400)
const SPAWN_POS1 = Vector2(250,400)
var playerScene: PackedScene  

func add_player(peer_id: int):
	var player = playerScene.instantiate()
	player.name = str(peer_id)
	get_node("PlayerManager").call_deferred("add_child", player)
	
	

func _ready():
	self.playerScene = load(get_node("MultiplayerSpawner").get_spawnable_scene(0))
