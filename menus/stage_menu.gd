
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var grid = get_node("GridContainer")
	var button = preload("res://menus/stage_button.scn")
	for i in range(1,31):
		var b = button.instance()
		
		b.set_text(str(i))
		b.set_name(str(i))
		b.set_flat(true)
		grid.add_child(b)
	pass
	