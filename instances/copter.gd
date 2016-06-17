
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
signal enemy_died
var type = "copter"
var speed = 300
var health = 2
var power = 2


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_exit",self, "_body_exit")
	add_to_group("enemies")
	set_linear_velocity(get_linear_velocity().normalized() * speed)
	pass

func _body_exit(body):
	var vel =  get_linear_velocity().normalized() * speed
	set_linear_velocity(vel)
	#set_angular_velocity(sign(rand_range(-1,1)) * angular)
	if body.type == "egg" or body.type == "bonus_base":
		body.damage(power)
	elif body.type == "player":
		body.damage(power)
	pass

func damage(value):
	health -= value
	if health <= 0:
		dead()
		

func _on_Timer_timeout():
	dead()
	pass # replace with function body

func dead():
	for i in range(0,2):
		var egg = preload("res://instances/spore.scn").instance()
		egg.set_pos(get_pos())
		get_parent().add_child(egg)
	queue_free()
