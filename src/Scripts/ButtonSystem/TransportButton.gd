extends InteractableNode

@export var group: String = ""

func interact(player: Node3D):
	if !enabled:
		super.interact(player)
	if !group.is_empty():
		var transport = get_tree().get_first_node_in_group(group)
		if transport != null:
			if transport is TransportSystem:
				transport.interact()
