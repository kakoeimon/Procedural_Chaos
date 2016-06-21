
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var stage = get_node("../../.")
var speed = 100
var type = "bonus_base"
var power = 3
var dir = Vector2(1,0)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_enter", self, "_body_enter")
	stage.get_node("Enemy_SamplePlayer").play("eggs")
	pass

func _body_enter(body):
	if body.type == "bonus_spore":
		var egg = preload("res://instances/bonus_base.scn").instance()
		egg.set_pos(get_pos())
		get_parent().add_child(egg)
		queue_free()
	elif body.type == "infant" or body.type == "berserker":
		body.damage(power)
		stage.get_node("Enemy_SamplePlayer").play("Hit")
		queue_free()

func _shoot():
	var b = preload("bullet.scn")
	var n = b.instance()
	n.add_collision_exception_with(self)
	n.set_pos(get_pos())
	n.set_linear_velocity(dir)
	get_parent().add_child(n)

func damage(value):
		queue_free()