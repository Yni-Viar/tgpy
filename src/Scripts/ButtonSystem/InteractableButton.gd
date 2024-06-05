extends InteractableNode


func interact(player: Node3D):
	if !enabled:
		super.interact(player)
	if get_parent().has_method("interact"):
		get_parent().call("interact", player)
	super.interact(player)
