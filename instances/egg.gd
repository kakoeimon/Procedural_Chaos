
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var stage = get_node("../../.")
onready var game_table = get_tree().get_current_scene()
onready var anim = get_node("AnimationPlayer")
var type = "egg"
var health = 3

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	anim.seek(rand_range(0.0,1.0))
	add_to_group("enemies")
	add_to_group("eggs")
	stage.get_node("Enemy_SamplePlayer").play("eggs")
	pass
	
func damage(value):
	if health > 0:
		anim.play("damage")
		health -= value
		if health <= 0:
			for i in range(0,2):
				var egg = game_table.infant.instance()
				egg.set_pos(get_pos())
				get_parent().add_child(egg)
			stage.get_node("Enemy_SamplePlayer").play("egg_break")
			queue_free()
		

func replicate():
	var egg = game_table.egg.instance()
	egg.set_pos(get_pos() + Vector2(rand_range(0,1), rand_range(0,1)))
	get_parent().add_child(egg)

