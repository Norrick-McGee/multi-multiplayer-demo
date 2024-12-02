extends Node
class_name NetMan

var eNetPeer = ENetMultiplayerPeer.new()


func conn_init(conn:Dictionary):
	"""
	conn= {
			'type':'client', # or host, (ipv4 will not be present if type is host)
			'ipv4':'127.0.0.1', 
			'port':6767
		}
	"""
	# TODO: Add a bunch of stuff for handling player connects, disconnects, reconnects etc.
	
	if conn['type'].to_lower() == 'host':
		eNetPeer.create_server(conn['port'])
	elif conn['type'].to_lower() == 'client':
		eNetPeer.create_client(
			conn['ipv4'],
			conn['port']
			)
	multiplayer.multiplayer_peer = eNetPeer
