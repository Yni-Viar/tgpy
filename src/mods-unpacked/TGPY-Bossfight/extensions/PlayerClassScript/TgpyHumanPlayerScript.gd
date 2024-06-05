extends HumanPlayerScript

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var ray: RayCast3D
@export var level: int = 1
var sound_path: AudioStreamPlayer3D
@export var hit_sounds: Array[AudioStream]

func on_start():
	sound_path = get_parent().get_parent().get_node("InteractSound")
	ray = get_parent().get_parent().get_node("PlayerHead/PlayerRecoil/RayCast3D")

func on_update(delta):
	if Input.is_action_just_pressed("attack"):
		if ray.is_colliding():
			var collider = ray.get_collider()
			sound_path.stream = hit_sounds[rng.randi_range(0, hit_sounds.size() - 1)]
			sound_path.play()
			if collider is BossCommon:
				collider.rpc("health_manage", -8 * level, get_parent().get_parent().get_path())
			elif collider is PlayerScript:
				if collider.unique_type_id == 1:
					collider.rpc("health_manage", -20, 0, "Don't be a bad boy")
