
extends Node2D
onready var stage = get_node("Stage")
onready var timer = get_node("Timer")
var deaths = 0
var player
var controls


func _ready():
	get_tree().set_auto_accept_quit(false)
	_demo()
	if OS.has_touchscreen_ui_hint():
		controls = preload("controls/touch_controls.scn").instance()
	else:
		controls = preload("controls/mouse_controls.scn").instance()
	controls.hide()
	add_child(controls)
	set_process(true)
	
func _process(delta):
	get_node("fps/Label").set_text(str(OS.get_frames_per_second()))
	
	
func _clear_stage():
	for i in get_node("Stage/Enemies").get_children():
		i.queue_free()
	for i in get_node("Stage/Players").get_children():
		i.queue_free()
			
func _player_died():
	deaths +=1
	#_clear_stage()
	#call_deferred("_player_stage_vars")
	#dddastage.call_deferred("_start_stage", stage.number)
	get_node("deaths/Number").set_text(str(deaths))
	player.set_fixed_process(false)
	player.health = 10000
	player.set_material(get_node("Stage/Enemies").get_material())
	player.set_use_parent_material(false)
	player.get_node("Particles2D").set_emitting(true)
	player.get_node("Particles2D").set_use_parent_material(true)
	player.set_bounce(0.5)
	player.disconnect("body_exit", player, "_body_exit")
	get_node("Change_Stage_Timer").start()
	
		
func _enemy_died():
	if get_node("Stage/Enemies").get_child_count() <= 2:
		stage.number +=1
		get_node("Change_Stage_Timer").start()
		for i in get_node("Stage/Players").get_children():
			i.set_gravity_scale(5)
	pass
	
func _player_stage_vars():
	if not has_node("Stage/Players/player"):
		
		player = preload("res://instances/player.scn").instance()
		player.set_pos(Vector2(320, 240))
		get_node("Stage/Players").add_child(player)
		player.set_name("player")
		
		player.connect("player_died",self, "_player_died")
		call_deferred("_player_stage_vars")
		
	player._reset_fire_rate()
	player._advance_fire_rate(0.1 * stage.number)
	#player.max_vel = 200 + 5*stage.number
	player.acc = 2000 + 100*stage.number
	player.bullet_speed = 400 + 5*stage.number

func _on_Timer_timeout():
	var eggs = get_tree().get_nodes_in_group("eggs")
	eggs[rand_range(0,eggs.size()-1)].damage(5)
	pass # replace with function body

func _start_stage(number):
	get_node("Stage_Selector").hide()
	call_deferred("_player_stage_vars")
	stage._start_stage(number)
	#timer.set_wait_time(timer.get_wait_time() + stage.number)
	get_node("Stage_Number/Number").set_text(str(stage.number))
	get_node("deaths/Number").set_text(str(deaths))


func _on_Start_Button_pressed():
	get_node("Menu").hide()
	#get_node("Stage_Selector").show()
	deaths = 0
	stage.number = 1
	for i in get_tree().get_nodes_in_group("eggs"):
		i.set_gravity_scale(5)
	get_node("Change_Stage_Timer").start()
	controls.show()
	pass # replace with function body
	
func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		if not get_node("Menu").is_hidden():
			get_tree().quit()
		else:
			if get_node("Pause_Menu").is_hidden():
				get_node("Pause_Menu").show()
				controls.hide()
				get_tree().set_pause(true)
			else:
				get_node("Pause_Menu").hide()
				controls.show()
				get_tree().set_pause(false)

func _on_Resume_Button_pressed():
	get_node("Pause_Menu").hide()
	controls.show()
	get_tree().set_pause(false)
	pass # replace with function body


func _on_Exit_Menu_pressed():
	get_tree().set_pause(false)
	get_node("Pause_Menu").hide()
	_clear_stage()
	get_node("Menu").show()
	get_node("Change_Stage_Timer").stop()
	_demo()
	
	pass # replace with function body


func _on_Exit_Button_pressed():
	get_tree().quit()
	pass # replace with function body

func _demo():
	stage._start_stage(int(rand_range(15,30)))
	for i in get_tree().get_nodes_in_group("eggs"):
		i.set_linear_velocity(Vector2(rand_range(0,5), rand_range(0,5)))
		i.set_bounce(0.5)
		i.set_linear_damp(0)

func _on_Change_Stage_Timer_timeout():
	_clear_stage()
	call_deferred("_start_stage",stage.number)
	pass # replace with function body
