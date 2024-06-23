extends StaticBody3D




func _on_scp_173_defeated():
	$CableCarLaunch.enabled = true
	$scp173.queue_free()


func _on_elevator_changed_launch_state(start):
	if get_tree().root.get_node("Main/Game/Elevator").current_floor == 0 && !start:
		get_tree().root.get_node("Main/Game/Elevator").locked = true
		get_tree().root.get_node("Main/Game/Elevator/ButtonInteractUp").enabled = false
		get_tree().root.get_node("Main/Game/Elevator/ButtonInteractDown").enabled = false
		get_tree().root.get_node("Main/Game/TestScene2/CableCarLaunch").enabled = false
