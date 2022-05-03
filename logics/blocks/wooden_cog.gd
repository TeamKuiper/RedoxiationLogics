extends "res://logics/blocks/block.gd"

func on_block_action(_world, _vec2, _action):
	pass

func on_block_placed(world, vec2):
	var tile = world.get_tile_entity(vec2)
	var check = tile.fill(vec2, 0, 1)
	tile.set_fill(world, vec2, check, 0)

func on_block_broken(world, vec2):
	var check = 0
	
	if check_state(world, Vector2(vec2.x+1, vec2.y), 1):
		world.get_tile_entity(Vector2(vec2.x+1, vec2.y)).fill(Vector2(vec2.x+1, vec2.y), 0, 1)
	if check_state(world, Vector2(vec2.x-1, vec2.y), 1):
		world.get_tile_entity(Vector2(vec2.x-1, vec2.y)).fill(Vector2(vec2.x-1, vec2.y), 0, 1)
	if check_state(world, Vector2(vec2.x, vec2.y+1), 1):
		world.get_tile_entity(Vector2(vec2.x, vec2.y+1)).fill(Vector2(vec2.x, vec2.y+1), 0, 1)
	if check_state(world, Vector2(vec2.x, vec2.y-1), 1):
		world.get_tile_entity(Vector2(vec2.x, vec2.y-1)).fill(Vector2(vec2.x, vec2.y-1), 0, 1)

	if check_state(world, Vector2(vec2.x+1, vec2.y), 0):
		check = world.get_tile_entity(Vector2(vec2.x+1, vec2.y)).chunk_number
		world.get_tile_entity(Vector2(vec2.x+1, vec2.y)).set_fill(world, Vector2(vec2.x+1, vec2.y), check, 0)
	if check_state(world, Vector2(vec2.x-1, vec2.y), 0):
		check = world.get_tile_entity(Vector2(vec2.x-1, vec2.y)).chunk_number
		world.get_tile_entity(Vector2(vec2.x-1, vec2.y)).set_fill(world, Vector2(vec2.x-1, vec2.y), check, 0)
	if check_state(world, Vector2(vec2.x, vec2.y+1), 0):
		check = world.get_tile_entity(Vector2(vec2.x, vec2.y+1)).chunk_number
		world.get_tile_entity(Vector2(vec2.x, vec2.y+1)).set_fill(world, Vector2(vec2.x, vec2.y+1), check, 0)
	if check_state(world, Vector2(vec2.x, vec2.y-1), 0):
		check = world.get_tile_entity(Vector2(vec2.x, vec2.y-1)).chunk_number
		world.get_tile_entity(Vector2(vec2.x, vec2.y-1)).set_fill(world, Vector2(vec2.x, vec2.y-1), check, 0)

func create_tile_entity():
	return create_tile_entity_by_name("wooden_cog")


func check_state(world, vec2, st):
	return world.get_block(vec2) == world.block_name_to_id['wooden_cog'] and world.get_tile_entity(vec2).state != st
