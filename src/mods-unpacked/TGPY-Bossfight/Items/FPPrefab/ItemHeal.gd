extends ItemUse

@export var amount_health: float = 50

func on_update(delta):
	if enable_using:
		if Input.is_action_just_pressed("attack"):
			on_use(player_path)

func on_use(player):
	player.rpc_id(multiplayer.get_unique_id(), "health_manage", amount_health, 0, "Heal")
	super.on_use(player)
