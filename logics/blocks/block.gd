extends Node

func _on_block_action(vec2, action):
	on_block_action(vec2, action)
	
	match action:
		"block_placed":
			on_block_placed(vec2)
		"block_broken":
			on_block_broken(vec2)

func on_block_action(_vec2, _action):
	pass

func on_block_placed(_vec2):
	pass

func on_block_broken(_vec2):
	pass

func create_tile_entity():
	return null

func create_tile_entity_by_name(name):
	var tile_entity = Sprite.new()
	tile_entity.set_script(load("res://logics/tileentities/" + name + ".gd"))
	tile_entity.set_tile_texture(load("res://images/" + name + ".png"))
	
	return tile_entity
