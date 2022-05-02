extends ScrollContainer


func add_block(id, name):
	var button = Button.new()
	button.icon = load("res://images/" + name + ".png")
	button.expand_icon = true
	button.rect_min_size = Vector2(32, 32)
	button.connect("pressed", get_parent(), "_on_block_selected", [id])
	add_child(button)
