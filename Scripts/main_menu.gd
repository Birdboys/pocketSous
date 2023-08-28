extends Control
@onready var endless_game = preload("res://Scenes/endless_game.tscn")
@onready var timed_game = preload("res://Scenes/time_game.tscn")

func _on_timed_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/time_game.tscn")
	pass # Replace with function body.

func _on_endless_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/endless_game.tscn")
	pass # Replace with function body.
