extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var block_scripts = {}
var tile_entities = {}

var selected_block_id = -1
var tick_delta_ms
var is_manual = false

var curTick = 0
var elapsed_delta_ms = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	is_manual = $ManualTickCheckButton.pressed
	update_manual_state(is_manual)
	apply_tick_delta()
	ready_script()

func _process(delta):
	if not is_manual:
		elapsed_delta_ms += delta*1000
		while elapsed_delta_ms >= tick_delta_ms:
			elapsed_delta_ms -= tick_delta_ms
			next_tick()
	
	
func ready_script():
	for id in $Blocks.tile_set.get_tiles_ids():
		var name = $Blocks.tile_set.tile_get_name(id)
		$BlockSelector.add_block(id, name)
		block_scripts[id] = load("res://logics/blocks/" + name + ".gd").new()
		block_scripts[id]._init_block(id)

func next_tick():
	for i in tile_entities:
		for j in tile_entities[i]:
			tile_entities[i][j].on_update()
	
	curTick += 1
	$CurrentTickLabel.text = "Tick " + str(curTick)

func get_tile_entity(vec2):
	if tile_entities.has(vec2.x) and tile_entities[vec2.x].has(vec2.y):
		return tile_entities[vec2.x][vec2.y]
	return null

func get_block(vec2):
	return $Blocks.get_cell(vec2)

func place_tile_entity(vec2, tile_entity):
	tile_entity.position = $Blocks.map_to_world(vec2)
	tile_entity._tile_init(self, vec2)
	if tile_entities.has(vec2.x):
		tile_entities[vec2.x][vec2.y] = tile_entity
	else:
		tile_entities[vec2.x] = {vec2.y: tile_entity}
	$TileEntities.add_child(tile_entity)

#TODO what if it is null? what if it is the only element?
func break_tile_entity(vec2):
	if tile_entities.has(vec2.x) and tile_entities[vec2.x].has(vec2.y):
		var tile_entity = tile_entities[vec2.x][vec2.y]
		tile_entities[vec2.x].erase(vec2.y)
		$TileEntities.remove_child(tile_entity)

func _on_block_selected(id):
	selected_block_id = id

func _on_tilemap_updated(vec2, action):
	var can_perform = ($Blocks.perform(vec2, selected_block_id, action))
	if block_scripts.has(selected_block_id) and block_scripts[selected_block_id] != null:
		
		if can_perform:
			if action == "block_placed":
				var tile_entity = block_scripts[selected_block_id].create_tile_entity()
				if tile_entity != null:
					place_tile_entity(vec2, tile_entity)
			
			block_scripts[selected_block_id]._on_block_action(self, vec2, action)
			
			if action == "block_broken":
				break_tile_entity(vec2)

func _on_autotick_toggled(is_true):
	update_manual_state(is_true)

func update_manual_state(is_man):
	is_manual = is_man
	elapsed_delta_ms = 0
	
	$NextTickButton.disabled = not is_manual
	
	if is_manual:
		$PlayingLabel.bbcode_text = "[color=#ff0000][b]Paused[/b][/color]"
	else:
		$PlayingLabel.bbcode_text = "[color=#00ff00][b]Playing[/b][/color]"


func _on_tick_apply():
	apply_tick_delta()

func apply_tick_delta():
	if $TickDeltaInput.text.is_valid_integer():
		tick_delta_ms = int($TickDeltaInput.text)
		elapsed_delta_ms = 0


func _on_next_tick_pressed():
	next_tick()
