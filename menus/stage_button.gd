
extends Button

# member variables here, example:
# var a=2
# var b="textvar"
onready var game_table = get_tree().get_current_scene()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	connect("pressed", self,"_run")
	pass
	
func _run():
	game_table._start_stage(int(get_text()))
	
