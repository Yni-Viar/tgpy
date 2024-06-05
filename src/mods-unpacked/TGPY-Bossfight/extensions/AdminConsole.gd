extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_btn_pressed():
	check_moderator()
	if !multiplayer.is_server() && !get_tree().root.get_node("Main/Game/" + str(multiplayer.get_unique_id())).is_moderator:
		get_tree().root.get_node("Main/Game/AdminCommands").rpc_id(1, "ask_for_moderator", multiplayer.get_unique_id(), $Password.text)
		check_moderator()
	hide()

func check_moderator():
	if get_tree().root.get_node("Main/Game/" + str(multiplayer.get_unique_id())).is_moderator:
		print("A moderator logged on")
		get_tree().root.get_node("Main/CanvasLayer/InGameConsole").show()
		get_parent().special_screen = get_tree().root.get_node("Main/CanvasLayer/InGameConsole").visible
