extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	GDsh.add_command("admin_grant", admin_grant, "Grant admin privilegies")
	GDsh.add_command("admin_ban", admin_ban, "Bans a player (admin access required)")
	GDsh.add_command("admin_kick", admin_kick, "Kicks a player (admin access required)")
	GDsh.add_command("get_peers", get_peers, "Gets all peers")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func admin_grant(args: Array):
	if args[0].is_empty():
		return "Provide a password!"
	else:
		#
		return "Processing your request..."

func admin_ban(args: Array):
	if get_tree().root.get_node("Main/Game/" + str(multiplayer.get_unique_id())).is_admin:
		if args[0].is_empty():
			return "Provide a peer's id! You can find it in get_player_peers command..."
		if args[0] == "1":
			return "You cannot ban the server"
		get_parent().ban(int(args[0]))
		return "Successfully banned!"
	else:
		return "You are not granted to do this action!"

func admin_kick(args: Array):
	if get_tree().root.get_node("Main/Game/" + str(multiplayer.get_unique_id())).is_admin:
		if args[0].is_empty():
			return "Provide a peer's id! You can find it in get_player_peers command..."
		if args[0] == "1":
			return "You cannot kick the server"
		get_tree().root.get_node("Main").rpc_id(int(args[0]), "kick")
		return "Successfully kicked!"
	else:
		return "You are not granted to do this action!"

func get_peers(args: Array):
	var s: String = ""
	for peer in get_parent().get_children():
		if peer is PlayerScript:
			s += peer.name + " - " + peer.player_name
	return s

@rpc("any_peer")
func ask_for_admin(peer_id: int, password: String):
	if hash(password) == hash(get_parent().admin_password):
		get_parent().rpc_id(peer_id, "grant_admin_privilegies", peer_id)

func ask_for_admin_connector(password: String):
	rpc_id(1, "ask_for_admin", multiplayer.get_unique_id(), password)

@rpc("any_peer")
func ask_for_moderator(peer_id: int, password: String):
	if hash(password) == hash(get_parent().moderator_password):
		get_parent().rpc_id(peer_id, "grant_admin_privilegies", peer_id)

