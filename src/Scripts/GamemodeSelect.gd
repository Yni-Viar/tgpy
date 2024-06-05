extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready():
	var counter = 0
	for m in ModLoaderStore.mod_data:
		add_item(m, counter)
		counter += 1
	get_tree().root.get_node("Main").game_mode = get_item_text(selected)



func _on_item_selected(index):
	get_tree().root.get_node("Main").game_mode = get_item_text(index)
	get_tree().root.get_node("Main").set_data()
