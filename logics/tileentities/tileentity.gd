extends Sprite

var world

var xPos
var yPos

func _tile_init(wrld, vec2):
	world = wrld
	xPos = vec2.x
	yPos = vec2.y

func set_tile_texture(txture):
	texture = txture

func on_update():
	pass
