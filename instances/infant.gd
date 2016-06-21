
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var stage = get_node("../../.")
var type = "infant"
var health = 1
var speed = 200
var power = 1
var grown = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_enter",self,"_enter_body")
	add_to_group("enemies")
	var vel = Vector2(1,0).rotated(rand_range(-PI, PI)) * speed
	set_linear_velocity(vel)
	pass
	
func damage(value):
	health -= value
	if health <= 0:
		var egg = preload("res://instances/spore.scn").instance()
		egg.set_pos(get_pos())
		get_parent().add_child(egg)
		queue_free()

func _enter_body(body):
	if body.type == "player":
		body.damage(power)
		stage.get_node("Enemy_SamplePlayer").play("Hit")
	elif grown: 
		if body.type == "spore":
			berserker()
			body.infant()
			
	
func berserker():
	var egg = preload("res://instances/berserker.scn").instance()
	egg.set_pos(get_pos())
	egg.set_rot(get_rot())
	egg.set_linear_velocity(get_linear_velocity())
	get_parent().add_child(egg)
	queue_free()
	pass # replace with function body
	
func grow():
	get_shape(0).set_radius(16)
	grown = true