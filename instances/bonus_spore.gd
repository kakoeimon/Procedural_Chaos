
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var stage = get_node("../../.")
onready var game_table = get_tree().get_current_scene()
var speed = 100
var type = "bonus_spore"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_enter", self, "_body_enter")
	var vel = Vector2(1,0).rotated(rand_range(-PI, PI)) * speed
	stage.get_node("Enemy_SamplePlayer").play("spore_pick")
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
	var egg = game_table.bonus_base.instance()
	egg.set_pos(get_pos())
	get_parent().add_child(egg)
	queue_free()