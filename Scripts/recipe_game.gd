extends Control
@onready var current_game = null
@onready var current_theme = null
@onready var next_game = null
@onready var mini_game = preload("res://Scenes/base_mini_game.tscn")
@onready var scene_transition = preload("res://Scenes/scene_transition.tscn")
@onready var prev_transition_type = null
@onready var pause_menu := preload("res://Scenes/pause_menu.tscn")
@onready var game_time := 0.0
@onready var games := []
@onready var num_games := 0
@onready var current_game_num := 0
@onready var dish := ""
@onready var timer = $timer
# Called when the node enters the scene tree for the first time.
func _ready():
	var data = RecipeManager.getRecipe(RecipeManager.current_recipe_buffer)
	if not data is Dictionary: print("RECIPE RETRIEVAL ERROR HELP AHH"); get_tree().quit()
	games = data['games']
	num_games = data['num_games']
	dish = data['recipe']
	
	var current_game_data = [games[current_game_num], GameMaster.getGame(games[current_game_num]['type']).instantiate()] 
	current_game = await createGame(current_game_data)
	current_theme = FoodMaster.food[current_game_data[0]['food'][1]]['theme']
	current_game.fadeIn()
	
func _process(delta):
	game_time += delta
	timer.text = "%.1f" % game_time + " "
func createGame(game_data):
	var new_game = mini_game.instantiate()
	add_child(new_game)
	move_child(new_game, 0)
	new_game.initialize(game_data)
	new_game.game_finished.connect(nextGame)
	new_game.pause.connect(pauseGame)
	return new_game

func nextGame(win):
	if not win:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn") 
		return
	current_game_num += 1
	if current_game_num == num_games:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn") 
		return
		
	var ogTheme = current_theme
	current_game.queue_free()
	current_game = null
	current_theme = null
	var new_game_data = [games[current_game_num], GameMaster.game_types[games[current_game_num]['type']].instantiate()]
	current_theme = FoodMaster.food[new_game_data[0]['food'][1]]['theme']
	
	var transition = scene_transition.instantiate()
	add_child(transition)
	transition.transition_done.connect(fadeInGame)
	transition.initialize("right-left", ogTheme, current_theme)

	current_game = createGame(new_game_data)
		
func fadeInGame():
	current_game.visible = true
	current_game.fadeIn()

func pauseGame():
	var new_menu = pause_menu.instantiate()
	add_child(new_menu)
	new_menu.unpause.connect(unPauseGame)
	get_tree().paused = true
	
func unPauseGame(id):
	match id:
		0: pass
		1: get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		2: get_tree().quit()

