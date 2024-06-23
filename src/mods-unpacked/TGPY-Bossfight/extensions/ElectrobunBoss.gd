extends BossCommon

@export var laser_beam_src: PackedScene
var gravity: float = 9.8
var gravity_vector = Vector3()
@export var attack_enable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !dormant && !target.is_empty():
		rotation_degrees.y += sin(3.14 * delta)
		for i in range(get_slide_collision_count()):
			var check_collision: KinematicCollision3D = get_slide_collision(i)
			var collided_with = check_collision.get_collider()
			if collided_with is PlayerScript:
				if collided_with.unique_type_id == -1:
					collided_with.rpc("health_manage", -10, 0, "Electrocuted")
	if is_on_floor():
		gravity_vector = Vector3.ZERO
	else:
		gravity_vector += Vector3.DOWN * gravity * delta
	set_velocity(gravity_vector)
	move_and_slide()


func _on_sense_body_entered(body):
	if body is PlayerScript:
		if body.unique_type_id == -1:
			$Timer.start(1.0)
			dormant = false
			target.append(body.name)
			boss_appear()


func _on_sense_body_exited(body):
	if body is PlayerScript:
		if body.unique_type_id == -1:
			if target.has(body.name):
				if target.size() == 1:
					$Timer.stop()
					dormant = true
			target.erase(body.name)
			boss_dissapear()

func attack():
	var type_of_attack: int = 0#rng.randi_range(0, 1)
	match type_of_attack:
		0:
			if attack_enable:
				for i in rng.randi_range(6, 12):
					var laser: Node3D = laser_beam_src.instantiate()
					laser.rotation_degrees = Vector3(rng.randf_range(0, 360), rng.randf_range(0, 360), rng.randf_range(0, 360))
					$Lasers.add_child(laser)
			else:
				for node in $Lasers.get_children():
					node.queue_free()
		_:
			print("State failed")


func _on_defeated():
	get_tree().root.get_node("Main/Game/TestScene3/Door/ButtonInteract2").enabled = true
	queue_free()


func _on_timer_timeout():
	if !dormant && !target.is_empty():
		if attack_enable:
			$Timer.start(rng.randf_range(6.0, 10.0))
			attack_enable = false
		else:
			$Timer.start(rng.randf_range(2.0, 3.5))
			attack_enable = true
		attack()
