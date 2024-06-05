extends InteractableNode

@export var boss_prefab: PackedScene
@export var boss_spawn_marker3d_path: String = "Main/Game/TestScene3/BossSpawn"
@export var optional_label: String = "Main/Game/TestScene3/HidingASecret"
@export var optional_text: String = "NOT_SO_FAST"
var first_start: bool = true

func interact(player: Node3D):
	if enabled: 
		if first_start:
			if get_tree().root.get_node_or_null(optional_label) != null:
				get_tree().root.get_node(optional_label).text = optional_text
			rpc("boss_spawn")
		else:
			get_parent().rpc("door_control", player.get_path(), -1)
	super.interact(player)

@rpc("any_peer", "call_local")
func boss_spawn():
	enabled = false
	first_start = false
	var boss_node: Node3D = boss_prefab.instantiate()
	get_tree().root.get_node(boss_spawn_marker3d_path).add_child(boss_node)
