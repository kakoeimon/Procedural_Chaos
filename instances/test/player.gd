
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

var _busy = false
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
var mouse_pos = Vector2()
var bullet_speed = 400

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	add_to_group("players")
	set_fixed_process(true)
	set_process_input(true)
	pass
	
	
func busy():
	_busy = true
	
func not_busy():
	_busy = false
	
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
			var v = (mouse_pos - get_global_pos()).normalized() * bullet_speed
			v = v.rotated(rand_range(-coil, coil))
			b.set_pos(get_pos())
			b.set_linear_velocity(v)
			get_parent().add_child(b)
	pass
	
func _input(e):
	
	if e.is_action("left"):
		left = e.pressed
		return
	elif e.is_action("right"):
		right = e.pressed
		return
	if e.is_action("up"):
		up = e.pressed
		return
	if e.is_action("down"):
		down = e.pressed
		return
		
	
	if e.is_action("fire"):
		fire = e.pressed
		return
	if e.type == 2:
		mouse_pos = e.pos
	
func damage(value):
	if not _busy:
		anim.play("Damaged")
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

