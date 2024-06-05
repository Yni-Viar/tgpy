extends Node

var available_languages: Array[String] = ["en", "ru"]
var dynamic_gi: bool
var ssao: bool
var ssil: bool
var ssr: bool
var fog: bool
var music: float
var sound: float
var fullscreen: bool
var mouse_sensitivity: float
var window_size: Vector2i
var language: String = "en"
var glow: bool = false
var touchscreen: bool = false
var default_settings: Dictionary = {
	"DynamicGi": false,
	"Ssao": false,
	"Ssil": false,
	"Ssr": false,
	"Fog": false,
	"Music": 1,
	"Sound": 1,
	"Fullscreen": false,
	"MouseSensitivity": 0.05,
	"WindowSize": Vector2i(1366, 768),
	"Language": available_languages[0],
	"Glow": false,
	"Touchscreen": DisplayServer.is_touchscreen_available()
}
#var available_settings: Array[String] = ["DynamicGi", "Ssao", "Ssil", "Ssr", #"Fog",
	#"Music", "Sound", "Fullscreen", "MouseSensitivity", "WindowSize", "Language", "Glow",
	#"TouchScreen"]
#var default_settings: Array = [false, false, false, false, #true,
	#1, 1, false, 0.05, Vector2i(1920, 1080), available_languages[0], false, 
	#DisplayServer.is_touchscreen_available()]

# Called when the node enters the scene tree for the first time.
func _ready():
	load_ini(true)

func save_default_settings():
	var ini: IniParser = IniParser.new()
	ini.save_ini("Settings", default_settings.keys(), default_settings.values(), "user://settings.ini")
	load_ini()

func load_ini(check_for_missing: bool = false):
	if !FileAccess.file_exists("user://settings.ini"):
		save_default_settings()
	
	if check_for_missing:
		check_if_a_setting_exist(default_settings.keys(), default_settings.values())
	
	var ini: IniParser = IniParser.new()
	var result: Array = ini.load_ini("user://settings.ini", "Settings", default_settings.keys())
	
	dynamic_gi = bool(result[0])
	ssao = bool(result[1])
	ssil = bool(result[2])
	ssr = bool(result[3])
	fog = bool(result[4])
	music = float(result[5])
	sound = float(result[6])
	fullscreen = bool(result[7])
	mouse_sensitivity = float(result[8])
	window_size = Vector2i(result[9])
	language = str(result[10])
	glow = bool(result[11])
	touchscreen = bool(result[12])

## DEPRECATED
func check_if_a_setting_exist(setting_values: Array, default_values: Array):
	var config: ConfigFile = ConfigFile.new()
	var err = config.load("user://settings.ini")
	
	if err != OK:
		save_default_settings()
		print("The Settings has not saved, saving default settings...")
	for i in range(setting_values.size()):
		if !config.has_section_key("Settings", setting_values[i]):
			config.set_value("Settings", setting_values[i], default_values[i])
	config.save("user://settings.ini")
