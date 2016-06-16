
extends Control

# member variables here, example:
# var a=2
# var b="textvar"
var left = false
var right = false
var up = false
var down = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)
	
	pass

func _input(e):
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		var player = players[0]
		var move_dir = Vector2()
	
		if e.is_action("left"):
			player.left = e.pressed
			return
		elif e.is_action("right"):
			player.right = e.pressed
			return
		if e.is_action("up"):
			player.up = e.pressed
			return
		if e.is_action("down"):
			player.down = e.pressed
			return
			
		
		if e.is_action("fire"):
			player.fire = e.pressed
			return
		if e.type == 2:
			player.shoot_dir = (e.pos - player.get_global_pos()).normalized()


