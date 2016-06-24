
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var stage = get_node("../../.")
onready var game_table = get_tree().get_current_scene()
onready var anim = get_node("AnimationPlayer")
var target
var type = "berserker"
var health = 1
var acc = 200
var power = 1
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_enter", self, "_body_enter")
	add_to_group("enemies")
	stage.get_node("Enemy_SamplePlayer").play("berserker")
	set_fixed_process(true)
	_fire()
	pass

func _fixed_process(delta):
	if has_node("../../Players/player"):
		target = get_node("../../Players/player")
		var dir = (target.get_pos() - get_pos()).normalized() * acc * delta
		var vel = get_linear_velocity() + dir
		set_linear_velocity(vel)
	
func _body_enter(body):
	if body.type == "player":
		body.damage(power)
	elif body.type == "spore":
		body.damage(power)
		acc +=100
		health +=1
		power +=1
	elif body.type == "stage":
		_fire()
		
		
func damage(value):
	health -=value
	if health <=0:
		for i in range(0,1):
			var egg = game_table.spore.instance()
			egg.set_pos(get_pos())
			get_parent().add_child(egg)
		queue_free()
	anim.play("damage")
	
func _fire():
	target = get_node("../../Players/player")
	var b = game_table.enemy_bullet.instance()
	var v = (target.get_pos() - get_pos()).normalized() * 300
	b.set_pos(get_pos())
	
	b.set_rot(v.angle())
	b.set_linear_velocity(v)
	get_parent().add_child(b)
	
func copter():
	var egg = game_table.copter.instance()
	egg.set_pos(get_pos())
	egg.set_linear_velocity(get_linear_velocity())
	get_parent().add_child(egg)
	queue_free()