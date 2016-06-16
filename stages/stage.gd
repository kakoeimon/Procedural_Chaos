
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var game_table = get_parent()
const type = "stage"
var number = 1
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
	
func damage(value):
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
	#while stage_modulate.r == random_color.r or stage_modulate.g == random_color.g or stage_modulate.b == random_color.b:
	#	random_color = _random_color()
	next_modulate = random_color
	_add_random_eggs(num, num*3)
	_set_color(stage_modulate)
	
	
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
