extends CharacterBody3D
class_name BossCommon

signal defeated
signal health_changed(current_health: int)

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@export var boss_name: String = ""
@export var health: float
@export var has_abilities: bool = false
@export var abilities_cooldown: float
@export var target: Array[String] = []
@export var dormant: bool = true
@export var boss_music_id: int = -1
@export var after_boss_music_id: int = -1

func _ready():
	health = health * get_tree().root.get_node("Main/Game").players_list.size()

@rpc("any_peer", "call_local")
func health_manage(_health: float):
	health += _health
	if health <= 0:
		defeated.emit()
		boss_dissapear()
	else:
		health_changed.emit()
		get_tree().root.get_node("Main/Game/PlayerUI/BossContainer/ProgressBar").value = health

func boss_appear():
	if is_multiplayer_authority():
		get_tree().root.get_node("Main/Game/PlayerUI/BossContainer/Label").text = boss_name
		get_tree().root.get_node("Main/Game/PlayerUI/BossContainer/ProgressBar").max_value = health
		get_tree().root.get_node("Main/Game/PlayerUI/BossContainer/ProgressBar").value = health
		get_tree().root.get_node("Main/Game/PlayerUI/BossContainer").show()
		get_tree().root.get_node("Main/Game").set_background_music(get_tree().root.get_node("Main/Game").music_to_play[boss_music_id])

@rpc("any_peer", "call_local")
func boss_dissapear():
	if is_multiplayer_authority():
		get_tree().root.get_node("Main/Game/PlayerUI/BossContainer").hide()
		get_tree().root.get_node("Main/Game").set_background_music(get_tree().root.get_node("Main/Game").music_to_play[after_boss_music_id])
