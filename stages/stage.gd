
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
signal no_enemies
onready var game_table = get_parent()
const type = "stage"
var number = 1
var deaths = 0
var starting_eggs = 0
var stage_modulate = Color(1.0, 0.0, 0.0)
var modulate = Color(0.0, 0.0, 0.0)
var next_modulate = _random_color()

func _ready():
	# Called every time the node is added to the scene.
	set_process(true)
	pass
	
func _process(delta):
	var eggs = get_tree().get_nodes_in_group("eggs")
	var color = next_modulate.linear_interpolate(stage_modulate , eggs.size() / float(starting_eggs + 1.0))
		
	if eggs.size():
		modulate = modulate.linear_interpolate(color, 0.05)
		_set_color(modulate)
		
	if get_node("Enemies").get_child_count() <= 2:
		_no_enemies()
		set_process(false)
	
func damage(value):
	pass
	
func _clear_stage():
	for i in get_node("Enemies").get_children():
		if not i.is_type("Label"):
			i.queue_free()
	for i in get_node("Players").get_children():
		if not i.is_type("Label"):
			i.queue_free()
	
func _no_enemies():
	var player = get_node("Players/player")
	number +=1
	get_node("Timer_Change_Stage").start()
	for i in get_node("Players").get_children():
		if i.get_instance_ID() != player.get_instance_ID() and not i.is_type("Polygon2D") and not i.is_type("Label"):
			i.set_gravity_scale(5)
			i.set_bounce(0.5)
	player.win()
	var edges = preload("res://stages/edges.scn").instance()
	get_node("Players").add_child(edges)
	pass
func _next_stage():
	number +=1
	_start_stage(number)

func _start_stage(num):
	number = num
	stage_modulate = next_modulate
	var random_color = _random_color()
	var edges = preload("edges.scn").instance()
	get_node("Enemies").add_child(edges)
	get_node("Timer_Stop_Editing").start()
	#while stage_modulate.r == random_color.r or stage_modulate.g == random_color.g or stage_modulate.b == random_color.b:
	#	random_color = _random_color()
	next_modulate = random_color
	_add_random_eggs(num, num*3)
	_set_color(stage_modulate)
	for i in get_tree().get_nodes_in_group("eggs"):
		i.set_linear_velocity(Vector2(rand_range(0,5), rand_range(0,5)))
		i.set_bounce(0.5)
		i.set_linear_damp(0)
	
	
func _add_random_eggs(islands = 1, population = 10):
	var enemies = get_node("Enemies")
	starting_eggs = 0
	for i in range(0,islands):
		var egg = preload("res://instances/egg.scn").instance()
		egg.set_pos( Vector2(rand_range(0,640) , rand_range(0,480)))
		enemies.add_child(egg)
		starting_eggs +=1
		
	for i in range(0,population):
		var eggs = get_tree().get_nodes_in_group("eggs")
		var i = rand_range(0, eggs.size())
		eggs[i].replicate()
		starting_eggs +=1
		
func _random_color():
	randomize()
	var color = Color(0,0,0)
	var r = rand_range(0,3)
	if r < 1.0:
		color.r = 1.0
		if rand_range(0,2) > 1.0:
			color.g = _random_three()
		else:
			color.b = _random_three()
	elif r < 2.0:
		color.g = 1
		if rand_range(0,2) > 1.0:
			color.r = _random_three()
		else:
			color.b = _random_three()
	else:
		color.b = 1
		if rand_range(0,2) > 1.0:
			color.r = _random_three()
		else:
			color.g = _random_three()
	
	return color
	
func _random_three():
	var r = rand_range(0,3)
	if r > 2:
		return 1
	elif r > 1:
		return 0.5
	else:
		return 0
		
func _set_color(color):
	get_node("Enemies").get_material().set_shader_param("modulate",color)
	get_node("Players").get_material().set_shader_param("modulate",color.inverted())
	pass


func _on_Timer_Stop_Editing_timeout():
	for egg in get_tree().get_nodes_in_group("eggs"):
		egg.set_bounce(0.1)
		egg.set_linear_damp(-1)
	pass # replace with function body


func _on_Timer_Change_Stage_timeout():
	set_process(true)
	_clear_stage()
	call_deferred("_start_stage", number)
	call_deferred("_player_stage_vars")
	get_node("Players/Label").set_text(str(number))
	pass # replace with function body

func _player_stage_vars():
	if not has_node("Players/player"):
		
		var player = preload("res://instances/player.scn").instance()
		player.set_pos(Vector2(320, 240))
		get_node("Players").add_child(player)
		player.set_name("player")
		
		player.connect("player_died",self, "_player_died")
		call_deferred("_player_stage_vars")
		return
	else:
		var player = get_node("Players/player")
		player._reset_fire_rate()
		player._advance_fire_rate(0.1 * number)
		#player.max_vel = 200 + 5*number
		#player.acc = 2000 + 100*number
		player.bullet_speed = 400 + 5*number
		
func _player_died():
	deaths +=1
	var player = get_node("Players/player")
	get_node("Enemies/Label").set_text(str(deaths))
	player.dead()
	player.set_material(get_node("Enemies").get_material())
	if deaths > number and get_parent().game_type == "arcade":
		var g = preload("res://stages/game_over.scn").instance()
		g.set_name("game_over")
		get_node("Players").add_child(g)
		return
	get_node("Timer_Change_Stage").start()