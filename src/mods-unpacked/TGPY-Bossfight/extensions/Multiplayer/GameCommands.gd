extends Node

@export var positions: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	GDsh.add_command("tp", teleport, "Teleports the player to a given arena", "Arena 0 is startup arena, arena 1 is SCP-173 fight, and a cable car station, arena 2 is final boss arena")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func teleport(args: Array):
	if args.size() == 1 && str(args[0]).is_valid_int():
		if int(args[0]) < positions.size() && int(args[0]) >= 0:
			get_tree().root.get_node("Main/Game/" + str(multiplayer.get_unique_id())).global_position = get_tree().root.get_node(positions[int(args[0])]).global_position
			return "Successfully forceclassed to a class with id " + args[0]
		else:
			return "Wrong number. Try different number, e.g. 0"
	else:
		return "You need ONLY 1 argument (number) to teleport."
