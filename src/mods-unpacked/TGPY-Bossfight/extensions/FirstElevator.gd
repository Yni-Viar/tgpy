extends ElevatorSystem


func on_update(delta):
	if objects_to_teleport.size() == get_tree().root.get_node("Main/Game").players_list.size():
		locked = false
	else:
		locked = true
