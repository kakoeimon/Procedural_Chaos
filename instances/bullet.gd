
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var stage = get_node("../../.")
var power = 1
var type = "bullet"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_enter", self, "_body_enter")
	stage.get_node("Bullet_SamplePlayer").play("Laser_Shoot")
	pass


func _body_enter(body):
	if body.has_method("damage"):
		if body.type == "bonus_spore":
			body.set_linear_velocity(-1 * get_linear_velocity())
		elif body.type == "spore":
			
			var egg = preload("res://instances/bonus_spore.scn").instance()
			egg.set_pos(body.get_pos())
			egg.set_rot(body.get_rot())
			egg.set_linear_velocity(body.get_linear_velocity())
			get_parent().add_child(egg)
			body.damage(body.health)
		elif body.type == "bonus_base":
			body.dir = get_linear_velocity()
			body._shoot()
			add_collision_exception_with(body)
			set_linear_velocity(get_linear_velocity())
			return
		else:
			body.damage(power)
	#stage.get_node("Bullet_Explode_SamplePlayer").play("Bullet_Explosion")
	queue_free()
	
func damage(value):
	pass
