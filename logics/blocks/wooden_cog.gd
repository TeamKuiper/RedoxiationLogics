extends "res://logics/blocks/block.gd"

func on_block_action(_vec2, _action):
	pass

func on_block_placed(_vec2):
	pass

func on_block_broken(_vec2):
	pass

func create_tile_entity():
	return create_tile_entity_by_name("wooden_cog")
