extends ItemUse
class_name WeaponManager

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@export var ammo_count: int
@export var reload_time: float = 1.0
@export var cooldown: float
@export var is_auto: bool
@export var damage: float
@export var recoil_target: Vector3
@export var poof_sounds: Array[AudioStream] = []
@export var reload_sound: AudioStream
var ammo: float
var fire_cooldown: float
var is_player_script: bool = false
var camera: Camera3D
var head: Node3D
var raycast: RayCast3D
var audio_player: AudioStreamPlayer3D
var is_reloading = false

func _init():
	enable_using = false

func on_ready():
	if player_path != null:
		ammo = ammo_count
		head = player_path.get_node("PlayerHead")
		camera = player_path.get_node("PlayerHead/PlayerRecoil/PlayerCamera")
		raycast = player_path.get_node("PlayerHead/PlayerRecoil/VisionRadius")
		audio_player = player_path.get_node("InteractSound")
		player_path.get_node("PlayerHead/PlayerRecoil").call("set_recoil", recoil_target)
		fire_cooldown = 0

func on_update(delta):
	if player_path != null:
		if is_auto:
			if Input.is_action_pressed("weapon_shoot"):
				if is_cooldown_ended() && !is_reloading:
					shoot()
		else:
			if Input.is_action_just_pressed("weapon_shoot"):
				if is_cooldown_ended() && !is_reloading:
					shoot()
		if Input.is_action_just_pressed("weapon_reload"):
			rpc("reload", false)
		if fire_cooldown > 0:
			fire_cooldown -= delta
## Poof!
func shoot():
	if raycast.is_colliding():
		rpc("shoot_networked")
		var collider = raycast.get_collider()
		if collider is PlayerScript && collider.name != str(multiplayer.get_unique_id()):
			collider.rpc_id(int(collider.name), "health_manage", -damage, 0, "Shot")
		if collider is BossCommon:
			collider.rpc("health_manage", -damage)
		ammo -= 1
		if ammo <= 0:
			rpc("reload", true)

@rpc("any_peer", "call_local")
func shoot_networked():
	if audio_player != null:
		audio_player.stream = poof_sounds[rng.randi_range(0, poof_sounds.size() - 1)]
		audio_player.play()
	
	fire_cooldown = cooldown
	player_path.get_node("PlayerHead/PlayerRecoil").call("recoil_fire", false)

@rpc("any_peer", "call_local")
func reload(force: bool):
	if !is_reloading:
		if audio_player != null:
			audio_player.stream = reload_sound
			audio_player.play()
		if get_node_or_null("AnimationPlayer") != null:
			get_node("AnimationPlayer").play("reload")
		is_reloading = true
		await get_tree().create_timer(reload_time).timeout
		ammo = ammo_count
		is_reloading = false
	elif !force:
		await get_tree().create_timer(0.3).timeout

func is_cooldown_ended() -> bool:
	if fire_cooldown > 0:
		return false
	else:
		return true
