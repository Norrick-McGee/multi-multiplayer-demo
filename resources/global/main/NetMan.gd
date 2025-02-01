extends Node
class_name NetMan

var eNetPeer = ENetMultiplayerPeer.new()
var user_context: Dictionary

var waiting_room = {}
var auto_admit =  false
var fully_connected_players = {}

func conn_init(conn:Dictionary):
	"""
	conn = {
			'type':'client', # or host, (ipv4 will not be present if type is host)
			'ipv4':'127.0.0.1', 
			'port':6767
		}
	"""
	# TODO: Add a bunch of stuff for handling player connects, disconnects, reconnects etc.
	
	if conn['type'].to_lower() == 'host':
		eNetPeer.create_server(conn['port'])
		multiplayer.peer_connected.connect(_on_peer_connected)
	elif conn['type'].to_lower() == 'client':
		eNetPeer.create_client(
			conn['ipv4'],
			conn['port']
			)
	multiplayer.multiplayer_peer = eNetPeer
	user_context['netid'] = multiplayer.get_unique_id()

func _on_peer_connected(peer_id: int):
	# put in waiting room with details
	print("peer connected: {id}".format({'id':peer_id}))
	give_me_your_user_context_so_i_can_move_you_to_waiting_room.rpc_id(peer_id)
	

@rpc("any_peer", "call_local", "reliable")
func give_me_your_user_context_so_i_can_move_you_to_waiting_room():
	send_host_my_user_context_so_i_can_enter_waiting_room.rpc_id(1, self.user_context)
	
@rpc("any_peer", "call_local", "reliable")
func send_host_my_user_context_so_i_can_enter_waiting_room(context):
	multiplayer.get_remote_sender_id()
	var sender_info = context['netid']
	waiting_room[sender_info] = context

func get_waiting_room():
	pass
func admit_netid(netid:int):
	fully_connected_players[netid] = waiting_room[netid] 
	waiting_room.erase(netid)
	print('{netid} admitted'.format({'netid':netid}))
func deny_netid(netid:int):
	print("add force disconnect logic here")
	pass

func _process(delta):
	if waiting_room:
		for netid in waiting_room.keys():
			admit_netid(netid)
