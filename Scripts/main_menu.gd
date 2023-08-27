extends Control
@onready var endless_game = preload("res://Scenes/endless_game.tscn")
@onready var timed_game = preload("res://Scenes/time_game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("MAIN MENU")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print('wenis')
	pass



func _on_gui_input(event):
	#print(event)
	pass # Replace with function body.


func _on_timed_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/time_game.tscn")
	pass # Replace with function body.


func _on_endless_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/endless_game.tscn")
	pass # Replace with function body.
