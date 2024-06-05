extends BossCommon

@export var speed: float = 40.0;
@export var is_watching: bool = false
@export var current_target: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !dormant && !current_target.is_empty():
		if get_tree().root.get_node("Main/Game/" + current_target + "/PlayerModel/").get_child(0) is HumanPlayerScript:
			var human = get_tree().root.get_node("Main/Game/" + current_target + "/PlayerModel/").get_child(0)
			if human.is_blinking || !is_watching:
				var player_direction: Vector3 = global_position.direction_to(get_tree().root.get_node("Main/Game/" + current_target).global_position)
				velocity += speed * player_direction * delta
				look_at(get_tree().root.get_node("Main/Game/" + current_target).global_position)
			else:
				velocity = Vector3.ZERO
		else:
			velocity = Vector3.ZERO
	else:
		velocity = Vector3.ZERO
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var check_collision: KinematicCollision3D = get_slide_collision(i)
		var collided_with = check_collision.get_collider()
		if collided_with is PlayerScript:
			if collided_with.unique_type_id == -1:
				collided_with.rpc("health_manage", -16777216, 0, "Crunched by the Statue")
				super.boss_dissapear(collided_with)

func _on_sense_body_entered(body):
	if body is PlayerScript:
		if body.unique_type_id == -1:
			target.append(body.name)
			current_target = body.name
			dormant = false
			boss_appear(body)


func _on_sense_body_exited(body):
	if body is PlayerScript:
		if body.unique_type_id == -1:
			if current_target == body.name:
				if target.size() == 1:
					dormant = true
					current_target = ""
				else:
					current_target = target[rng.randi_range(0, target.size() - 1)]
			target.erase(body.name)
			boss_dissapear(body)

func boss_dissapear(body):
	super.boss_dissapear(body)
	queue_free()


func _on_dont_look_at_me_screen_entered():
	is_watching = true


func _on_dont_look_at_me_screen_exited():
	is_watching = false
