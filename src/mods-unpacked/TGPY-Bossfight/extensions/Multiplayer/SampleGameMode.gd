extends FacilityManager
class_name SampleGameMode

var admin_password: String = "change_me_please"
var moderator_password: String = ""

func _enter_tree():
	var ini: IniParser = IniParser.new()
	if !FileAccess.file_exists("user://defaultgame.ini"):
		ini.save_ini("SampleGamemode", ["Admin", "Moderator"], ["change_me_please", ""], "user://defaultgame.ini")
	else:
		admin_password = ini.load_ini("user://defaultgame.ini", "SampleGamemode", ["Admin"])[0]
		moderator_password = ini.load_ini("user://defaultgame.ini", "SampleGamemode", ["Moderator"])[0]
	if !FileAccess.file_exists("user://bans.txt"):
		var txt: TxtParser = TxtParser.new()
		txt.save("user://bans.txt", "")
	if multiplayer.get_unique_id() != 1:
		rpc_id(1, "check_if_banned")

func on_start():
	$PlayerUI/PreRoundStartPanel.show()

func on_server_start():
	wait_for_beginning()

func on_update(delta: float):
	if !is_round_started:
		get_node("PlayerUI/PreRoundStartPanel/PreRoundStart/Amount").text = str(players_list.size())
		
## Waits for people gather before the round starts.
func wait_for_beginning():
	await get_tree().create_timer(15.0).timeout
	if !is_round_started:
		begin_game()
	#if get_parent().spawn_npcs:
		#if rng.randi_range(0, 3) <= 2 && players_list.size() > 1:
			#var key: int = rng.randi_range(0, game_data.npcs.size() - 1):
				#get_node()

## Round start. Adds the players in the list and tosses their classes.
func begin_game():
	var players: Array[Node] = get_tree().get_nodes_in_group("Players")
	var i: int = 1
	is_round_started = true
	for player in players:
		if player is PlayerScript:
			rpc_id(int(str(player.name)), "set_player_class", str(player.name), toss_player_class(i), "Round start", false)
			rpc_id(int(str(player.name)), "hide_lobby")
			i += 1
## Tosses player classes at round start.
## This is sample implementation of this
func toss_player_class(i: int):
	if i == 2 || i % 8 == 0:
		return 2
	else:
		return 1

## Round end checker.
func check_round_end():
	await get_tree().create_timer(720.0).timeout
	round_end(0)

## Round end scenario. After 15 seconds shutdowns the server.
@rpc("any_peer", "call_local")
func round_end(who_won: int):
	match who_won:
		0:
			get_node("PlayerUI/GameEnd").text = "Stalemate!\nThe server will be turned off soon..."
		1:
			get_node("PlayerUI/GameEnd").text = "All bosses has been knocked down and players got to finish area!\nThe server will be turned off soon..."
	get_node("PlayerUI/AnimationPlayer").play("roundend")
	set_process(false)
	await get_tree().create_timer(15.0).timeout
	get_parent().server_disconnected()
## Forces round start.
func force_round_start():
	if !is_round_started:
		is_round_started = true
		if multiplayer.is_server():
			begin_game()
## hides lobby after start
@rpc("any_peer", "call_local")
func hide_lobby():
	$PlayerUI/PreRoundStartPanel.hide()

## bans a player
func ban(id: int):
	get_parent().rpc_id(id, "kick")
	rpc_id(1, "add_detention_note", get_parent().get_peer(id))

@rpc("any_peer")
func add_detention_note(ip: String):
	var txt: TxtParser = TxtParser.new()
	var s: String = txt.load("user://bans.txt")
	s += "\n" + ip
	txt.save("user://bans.txt", s)

@rpc("any_peer")
func grant_admin_privilegies(peer_id: int):
	get_node(str(peer_id)).is_admin = true
	print(str(peer_id) + "became admin")

@rpc("any_peer")
func grant_moderator_privilegies(peer_id: int):
	get_node(str(peer_id)).is_moderator = true
	print(str(peer_id) + "became moderator")

@rpc("any_peer")
func check_if_banned(id: int):
	var txt: TxtParser = TxtParser.new()
	if txt.open("user://bans.txt").contains(get_parent().get_peer(id)):
		get_parent().rpc_id(id, "kick")
