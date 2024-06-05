extends Node


const AUTHORNAME_MODNAME_DIR := "TGPY-Bossfight"
const AUTHORNAME_MODNAME_LOG_NAME := "TGPY-Bossfight:Main"

var mod_dir_path := "res://mods-unpacked/TGPY-Bossfight"
var extensions_dir_path := ""
var translations_dir_path := ""

func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions") # Godot 4

		# ModLoaderMod.install_script_extension(extensions_dir_path.plus_file(...))



func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")
	for s in Settings.available_languages:
		var translation_file_path: String = translations_dir_path.path_join("tgpy_bossfight." + s + ".translation")
		ModLoaderMod.add_translation(translation_file_path)


func _ready() -> void:
	# Add extensions
	install_script_extensions()
	# Add translations
	add_translations()
	ModLoaderLog.info("Ready!", AUTHORNAME_MODNAME_LOG_NAME)
