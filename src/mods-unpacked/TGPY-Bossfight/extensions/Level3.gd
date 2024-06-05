extends StaticBody3D


func _on_round_ender_body_entered(body):
	get_parent().rpc("round_end", 1)
