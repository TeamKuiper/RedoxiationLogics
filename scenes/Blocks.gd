extends TileMap

signal tilemap_event(vec2, action)

var action_dict = {}
var ongoing_action = []

func _init():
	var actions = InputMap.get_actions()
	for action in actions:
		var inputs = InputMap.get_action_list(action)
		for input in inputs:
			var input_type = input.get_class()
			var input_val = get_input_val(input)
			
			if input_type != null:
				if action_dict.has(input_type):
					if action_dict[input_type].has(input_val):
						action_dict[input_type][input_val].append(action)
					else:
						action_dict[input_type][input_val] = [action]
				else:
					action_dict[input_type] = {input_val: [action]}
					
		
func _input(event):
	if get_input_val(event) != null:
		if event.is_pressed():
			ongoing_action = get_actions(event)
			
			if ongoing_action == null:
				ongoing_action = []
			
			var vec2 = world_to_map(get_viewport().get_mouse_position())
			for action in ongoing_action:
				emit_signal("tilemap_event", vec2, action)
		else:
			ongoing_action = []
	elif event is InputEventMouseMotion:
		var vec2 = world_to_map(get_viewport().get_mouse_position())
		for action in ongoing_action:
			emit_signal("tilemap_event", vec2, action)
		

func get_actions(event):
	var input_type = event.get_class()
	if action_dict.has(input_type):
		var input_val = get_input_val(event)
		if action_dict[input_type].has(input_val):
			return action_dict[input_type][input_val]
	
	return null

func get_input_val(input):
	var input_type = input.get_class()
	match input_type:
		"InputEventKey":
			return input.scancode
		"InputEventMouseButton":
			return input.button_index
	
	return null

func perform(vec2, id, action):
	match action:
		"block_placed":
			return place_block(vec2, id)
		"block_broken":
			return break_block(vec2)
	
	return true

func place_block(vec2, id):
	if id == -1 or get_cell(vec2.x, vec2.y) > -1:
		return false
	
	set_cell(vec2.x, vec2.y, id)
	return true

func break_block(vec2):
	if get_cell(vec2.x, vec2.y) == -1:
		return false
	
	set_cell(vec2.x, vec2.y, -1)
	return true
