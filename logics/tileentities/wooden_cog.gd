extends "res://logics/tileentities/tileentity.gd"

var chunk_number = 0
var ang_vel = 0
var state

func on_update():
	if chunk_number != 0:
		ang_vel = 1.0 / chunk_number
	else:
		ang_vel = 0
	print(xPos, " ", yPos, " ", ang_vel)
	
	rotation_degrees += ang_vel
	if rotation_degrees >= 360:
		rotation = rotation - 360
	
func check_state(vec2, st):
	return world.get_block(vec2) == world.block_name_to_id['wooden_cog'] and world.get_tile_entity(vec2).state != st

func fill(vec2, check_num, st):
	check_num += 1
	var tile = world.get_tile_entity(vec2)
	tile.state = st
	
	if check_state(Vector2(vec2.x+1, vec2.y), st):
		check_num = fill(Vector2(vec2.x+1, vec2.y), check_num, st)
	if check_state(Vector2(vec2.x-1, vec2.y), st):
		check_num = fill(Vector2(vec2.x-1, vec2.y), check_num, st)
	if check_state(Vector2(vec2.x, vec2.y+1), st):
		check_num = fill(Vector2(vec2.x, vec2.y+1), check_num, st)
	if check_state(Vector2(vec2.x, vec2.y-1), st):
		check_num = fill(Vector2(vec2.x, vec2.y-1), check_num, st)
	
	tile.chunk_number = check_num
	return check_num

func set_fill(world, vec2, check_num, st):
	var tile = world.get_tile_entity(vec2)
	tile.state = st
	tile.chunk_number = check_num
	
	if check_state(Vector2(vec2.x+1, vec2.y), st):
		set_fill(world, Vector2(vec2.x+1, vec2.y), check_num, st)
	if check_state(Vector2(vec2.x-1, vec2.y), st):
		set_fill(world, Vector2(vec2.x-1, vec2.y), check_num, st)
	if check_state(Vector2(vec2.x, vec2.y+1), st):
		set_fill(world, Vector2(vec2.x, vec2.y+1), check_num, st)
	if check_state(Vector2(vec2.x, vec2.y-1), st):
		set_fill(world, Vector2(vec2.x, vec2.y-1), check_num, st)
	
	tile.chunk_number = check_num
	return check_num
