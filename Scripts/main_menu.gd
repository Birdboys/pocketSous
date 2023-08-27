extends Control
@onready var endless_game = preload("res://Scenes/endless_game.tscn")
@onready var timed_game = preload("res://Scenes/time_game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("MAIN MENU")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass


func _on_button_pressed():
	get_tree().change_scene_to_packed(timed_game)
	pass # Replace with function body.


func _on_button_2_pressed():
	get_tree().change_scene_to_packed(endless_game)
	pass # Replace with function body.
