
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func analog_force_change(force, analog):
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		var player = players[0]
		var force_length = force.length()
		if force_length <= 0.1:
			force = Vector2()
		if analog.name == "move":
			if force_length < 0.5:
				player.move_dir = force
			else:
				player.move_dir = force.normalized()
			
		if analog.name == "shoot":
			player.shoot_dir = force.normalized()
			if force_length > 0.2:
				player.fire = true
			else:
				player.fire = false
	pass