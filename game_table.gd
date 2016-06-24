
extends Node2D
onready var stage = get_node("Stage")
onready var timer = get_node("Timer")
var deaths = 0
var player
var controls
var game_type = ""
var bullet = preload("res://instances/bullet.scn")
var egg = preload("res://instances/egg.scn")
var infant = preload("res://instances/infant.scn")
var berserker = preload("res://instances/berserker.scn")
var copter = preload("res://instances/copter.scn")
var spore = preload("res://instances/spore.scn")
var enemy_bullet = preload("res://instances/enemy_bullet.scn")
var bonus_spore = preload("res://instances/bonus_spore.scn")
var bonus_base = preload("res://instances/bonus_base.scn")

func _ready():
	get_tree().set_auto_accept_quit(false)
	_demo()
	if OS.has_method("has_touchscreen_ui_hint"):
		if OS.has_touchscreen_ui_hint():
			controls = preload("controls/touch_controls.scn").instance()
		else:
			controls = preload("controls/mouse_controls.scn").instance()
	else:
		controls = preload("controls/mouse_controls.scn").instance()
	add_child(controls)
	set_process_input(true)
	#set_process(true)
		
func _process(delta):
	get_node("fps/Label").set_text(str(OS.get_frames_per_second()))
	

func _on_Timer_timeout():
	var eggs = get_tree().get_nodes_in_group("eggs")
	eggs[rand_range(0,eggs.size()-1)].damage(5)
	pass # replace with function body

func _start_stage(number):
	get_node("Stage_Selector").hide()
	_on_Start_Button_pressed()
	stage.number = number
	game_type = "free"
	#timer.set_wait_time(timer.get_wait_time() + stage.number)
	

func _on_Start_Button_pressed():
	get_node("Menu").hide()
	game_type = "arcade"
	#get_node("Stage_Selector").show()
	stage.deaths = 0
	stage.number = 1
	get_node("Stage/Enemies/Label").set_text(str(0))
	get_node("Stage/Players/Label").set_text(str(0))
	for i in get_tree().get_nodes_in_group("eggs"):
		i.set_gravity_scale(5)
	stage.get_node("Timer_Change_Stage").start()
	get_node("Stage/Enemy_SamplePlayer").play("start")
	pass # replace with function body
	


func _on_Resume_Button_pressed():
	get_node("Pause_Menu").hide()
	get_tree().set_pause(false)
	pass # replace with function body


func _on_Exit_Menu_pressed():
	get_tree().set_pause(false)
	get_node("Pause_Menu").hide()
	stage._clear_stage()
	get_node("Menu").show()
	get_node("Stage/Timer_Change_Stage").stop()
	_demo()
	
	pass # replace with function body


func _on_Exit_Button_pressed():
	get_tree().quit()
	pass # replace with function body

func _demo():
	stage._start_stage(int(rand_range(15,30)))
	#stage.get_node("Timer_Stop_Editing").stop()
	

func _on_Free_Play_Button_pressed():
	get_node("Menu").hide()
	get_node("Stage_Selector").show()
	pass # replace with function body

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		if not get_node("Menu").is_hidden():
			get_tree().quit()
		else:
			if not get_node("Stage_Selector").is_hidden():
				get_node("Stage_Selector").hide()
				get_node("Menu").show()
				return
			if has_node("Stage/Players/game_over"):
				get_node("Stage/Players/game_over").queue_free()
				_on_Exit_Menu_pressed()
				return
				
			if get_node("Pause_Menu").is_hidden():
				get_node("Pause_Menu").show()
				get_tree().set_pause(true)
			else:
				get_node("Pause_Menu").hide()
				get_tree().set_pause(false)