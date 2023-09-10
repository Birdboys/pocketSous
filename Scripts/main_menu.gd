extends Control
@onready var endless_game = preload("res://Scenes/endless_game.tscn")
@onready var timed_game = preload("res://Scenes/time_game.tscn")
@onready var languages = {"en":"ENGLISH","es":"SPANISH","fr":"FRENCH"}
@onready var locales = ["en","es","fr"]
@onready var locale_index = 0
func _ready():
	TranslationServer.set_locale(locales[locale_index])
	$VBoxContainer/language.text = locales[locale_index].to_upper()
	
func _on_timed_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/time_game.tscn")
	pass # Replace with function body.

func _on_endless_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/endless_game.tscn")
	pass # Replace with function body.

func _on_change_language_pressed():
	locale_index = (locale_index + 1) % locales.size()
	TranslationServer.set_locale(locales[locale_index])
	$VBoxContainer/language.text = locales[locale_index].to_upper()
	pass # Replace with function body.

func _on_recipe_book_pressed():
	get_tree().change_scene_to_file("res://Scenes/recipe_menu.tscn")
