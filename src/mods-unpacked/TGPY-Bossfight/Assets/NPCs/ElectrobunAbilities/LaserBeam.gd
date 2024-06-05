extends RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var contact_point: Vector3
	if is_colliding():
		contact_point = to_local(get_collision_point())
		$MeshInstance3D.mesh.height = contact_point.y
		$MeshInstance3D.position.y = contact_point.y / 2
		var collided_with = get_collider()
		if collided_with is PlayerScript:
			if collided_with.unique_type_id == -1:
				collided_with.rpc("health_manage", -5, 0, "Electrocuted")
