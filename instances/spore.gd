
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
signal enemy_died
var type = "spore"
var health = 1
var power = 1
var grown = false
var speed = 100
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_enter",self, "_body_enter")
	connect("enemy_died", get_tree().get_current_scene(), "_enemy_died")
	var vel = Vector2(1,0).rotated(rand_range(-PI, PI)) * speed
	set_linear_velocity(vel)
	pass
func _body_enter(body):
	if grown:
		if body.type == "spore" or body.type == "bonus_base":
			var egg = preload("res://instances/egg.scn").instance()
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
	var egg = preload("res://instances/infant.scn").instance()
	egg.set_pos(get_pos())
	get_parent().add_child(egg)
	queue_free()
	
func damage(value):
	health -=value
	if health <=0:
		queue_free()
		emit_signal("enemy_died")
		
