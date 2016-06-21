
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var stage = get_node("../../.")
var power = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Area2D").connect("body_enter", self , "_body_enter")
	stage.get_node("Enemy_Bullet_SamplePlayer").play("Laser_Shoot2")
	pass


func _body_enter(body):
	if body.type == "player":
		body.damage(power)
		_dead()
	elif body.type == "stage":
		_dead()
	elif body.type == "bonus_base":
		_dead()
		
func _dead():
	stage.get_node("Enemy_SamplePlayer").play("Hit")
	queue_free()
	
	
	