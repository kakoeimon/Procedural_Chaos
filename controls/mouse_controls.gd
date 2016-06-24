
extends Control

# member variables here, example:
# var a=2
# var b="textvar"
onready var game_table = get_parent()
var left = false
var right = false
var up = false
var down = false
var shoot_dir = Vector2()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)
	
	pass

func _input(e):
	var players = get_tree().get_nodes_in_group("players")
	if e.is_action("exit"):
		if e.is_pressed() and not e.is_echo():
			get_parent().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
			return
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
			
		
		if e.type == 4:
			print(e)
			if e.axis == 0: #X
				if abs(e.value) > 0.03:
					player.move_dir.x = e.value
				else:
					player.move_dir.x = 0
				return
			if e.axis == 1: #Y
				if abs(e.value) > 0.03:
					player.move_dir.y = e.value
				else:
					player.move_dir.y = 0
				return
			if e.axis == 3: #X
				shoot_dir.x = e.value
				if shoot_dir.length() > 0.1:
					player.shoot_dir = shoot_dir.normalized()
					player.fire = true
				else:
					player.fire = false
				return
			if e.axis == 4: #Y
				shoot_dir.y = e.value
				if shoot_dir.length() > 0.1:
					player.shoot_dir = shoot_dir.normalized()
					player.fire = true
				else:
					player.fire = false
				return
		
		if e.is_action("fire"):
			player.fire = e.pressed
			return
		if e.type == 2:
			player.shoot_dir = (e.pos - player.get_global_pos()).normalized()


