extends Resource
class_name GameData

@export var classes: Array[BaseClass]
@export var items: Array[Item]
@export var map_objects: Array[PackedScene]
@export var npcs: Array[PackedScene]


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_classes: Array[BaseClass] = [], p_map_objects: Array[PackedScene] = [], p_npcs: Array[PackedScene] = []):
	classes = p_classes
	map_objects = p_map_objects
	npcs = p_npcs
