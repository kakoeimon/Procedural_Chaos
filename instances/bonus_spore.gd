
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var speed = 100
var type = "bonus_spore"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_enter", self, "_body_enter")
	var vel = Vector2(1,0).rotated(rand_range(-PI, PI)) * speed
	set_linear_velocity(vel)
	pass

func _body_enter(body):
	if body.type == "bonus_spore":
		bonus_base()
	elif body.type == "bonus_base":
		bonus_base()
	elif body.type == "player":
		bonus_base()
		

func damage(value):
	pass
	
func bonus_base():
	var egg = preload("res://instances/bonus_base.scn").instance()
	egg.set_pos(get_pos())
	get_parent().add_child(egg)
	queue_free()