
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
signal player_died
signal health_changed
onready var anim = get_node("AnimationPlayer")
var type = "player"
var acc = 2000
var max_vel = 200
var max_health = 5
var health = 1

var left = false
var right = false
var up = false
var down = false
var fire = false
const starting_fire_rate = 15
var fire_rate = 15
var fire_rate_timer = 0
var coil = 0.01
var auto_fire = false
var move_dir = Vector2()
var shoot_dir = Vector2()
var bullet_speed = 400

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	add_to_group("players")
	connect("body_enter", self , "_body_enter")
	connect("body_exit", self , "_body_exit")
	anim.play("Idle")
	set_fixed_process(true)
	pass
	
	
func eat(body):
	damage(-1)
	body.queue_free()
	
	
func _fixed_process(delta):
	var vel = get_linear_velocity()
	
	if left:
		vel.x -= acc * delta
	if right:
		vel.x += acc * delta
	
	if up:
		vel.y -= acc * delta
	if down:
		vel.y += acc * delta
	
	vel += move_dir * acc * delta
	
	if max_vel * max_vel < get_linear_velocity().length_squared():
		vel = get_linear_velocity().normalized()*max_vel
	
	vel *= 0.9
	set_linear_velocity(vel)
	
	fire_rate_timer -=1
	if fire or auto_fire:
		if fire_rate_timer <=0:
			fire_rate_timer = fire_rate
			var b = preload("bullet.scn").instance()
			b.add_collision_exception_with(self)
			var v = shoot_dir * bullet_speed
			v = v.rotated(rand_range(-coil, coil))
			b.set_pos(get_pos())
			b.set_linear_velocity(v)
			get_parent().add_child(b)
	pass
	

	
func damage(value = 1):
	health -= value
	emit_signal("health_changed",health)
	if health <= 0:
			
			emit_signal("player_died")
			

func _advance_fire_rate(value = 0.1):
	fire_rate /= 1 + value
	if fire_rate < 1:
		fire_rate_timer = 1
	coil = 0.01 * (starting_fire_rate / fire_rate)
	
	
func _reset_fire_rate():
	fire_rate = starting_fire_rate
	coil = 0.01 * (starting_fire_rate / fire_rate)

func _body_enter(body):
	if body.type == "stage":
		var material = get_node("../../Enemies").get_material()
		get_node("Particles2D").set_material(material)
		get_node("Particles2D").set_use_parent_material(false)
		anim.play("Burning")
		
func _body_exit(body):
	if body.type == "stage":
		anim.play("Idle")

