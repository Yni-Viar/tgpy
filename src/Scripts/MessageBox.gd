extends BaseWindow

@export var message = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = message
