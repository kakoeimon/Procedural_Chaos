
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var health = 1
var type = "egg"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func damage(value):
	health -=value
	if health <=0:
		emit_signal("enemy_died" , self)
		_dying()
	
func _dying():
	queue_free()