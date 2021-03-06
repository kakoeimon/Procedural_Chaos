
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var stage = get_node("../../.")
onready var game_table = get_tree().get_current_scene()
var type = "spore"
var health = 1
var power = 1
var grown = false
var speed = 100
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_enter",self, "_body_enter")
	var vel = Vector2(1,0).rotated(rand_range(-PI, PI)) * speed
	set_linear_velocity(vel)
	stage.get_node("Enemy_SamplePlayer").play("spore")
	pass
func _body_enter(body):
	if grown:
		if body.type == "spore" or body.type == "bonus_base":
			var egg = game_table.egg.instance()
			egg.set_pos(get_pos())
			get_parent().add_child(egg)
			queue_free()
			body.queue_free()
		elif body.type == "egg":
			infant()
			body.damage(body.health)
				

func grow():
	get_shape(0).set_radius(8)
	grown = true
	
func infant():
	var egg = game_table.infant.instance()
	egg.set_pos(get_pos())
	get_parent().add_child(egg)
	queue_free()
	
func damage(value):
	health -=value
	if health <=0:
		queue_free()
		
		
