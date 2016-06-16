
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var anim = get_node("AnimationPlayer")
var type = "egg"
var health = 3

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	anim.seek(rand_range(0.0,1.0))
	add_to_group("enemies")
	add_to_group("eggs")
	pass

func damage(value):
	anim.play("damage")
	health -= value
	if health <= 0:
		for i in range(0,2):
			var egg = preload("res://instances/infant.scn").instance()
			egg.set_pos(get_pos())
			get_parent().add_child(egg)
		queue_free()
		

func replicate():
	var egg = preload("res://instances/egg.scn").instance()
	egg.set_pos(get_pos() + Vector2(rand_range(0,1), rand_range(0,1)))
	get_parent().add_child(egg)

