
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var power = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Area2D").connect("body_enter", self , "_body_enter")
	pass


func _body_enter(body):
	if body.type == "player":
		body.damage(power)
		queue_free()
	elif body.type == "stage":
		queue_free()
	elif body.type == "bonus_base":
		queue_free()