extends Node
class_name NetMan

var eNetPeer = ENetMultiplayerPeer.new()

func conn_init(conn:Dictionary):
	"""
	conn = {
			'type':'client', # or host, (ipv4 will not be present if type is host)
			'ipv4':'127.0.0.1', 
			'port':6767
		}
	"""
	# Future TODO: I think that GameMan will change some traits in this node,
	# So make sure to reset NetMan on init. 
	# usecase: changing from 1 game mode to another, 1 game mode might allow re-joins, while another might not.
	# TODO: Add a bunch of stuff for handling player connects, disconnects, reconnects etc.
	
	if conn['type'].to_lower() == 'host':
		eNetPeer.create_server(conn['port'])
	elif conn['type'].to_lower() == 'client':
		eNetPeer.create_client(
			conn['ipv4'],
			conn['port']
			)
	multiplayer.multiplayer_peer = eNetPeer
