extends Control
@onready var current_game = null
@onready var current_theme = null
@onready var next_game = null
@onready var mini_game = preload("res://Scenes/base_mini_game.tscn")
@onready var scene_transition = preload("res://Scenes/scene_transition.tscn")
@onready var prev_transition_type = null
@onready var current_score := 0
@onready var game_time := 10.0
@onready var main_menu := preload("res://Scenes/main_menu.tscn")
@onready var pause_menu := preload("res://Scenes/pause_menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	print("TIMED GAME")
	var current_game_data = await GameMaster.generateRandomGame()
	current_game = await createGame(current_game_data)
	current_theme = FoodMaster.food[current_game_data[0]['food'][1]]['theme']
	current_game.fadeIn()
	
func createGame(game_data):
	var new_game = mini_game.instantiate()
	add_child(new_game)
	move_child(new_game, 0)
	new_game.initialize(game_data, game_time, current_score)
	new_game.game_finished.connect(nextGame)
	new_game.pause.connect(pauseGame)
	return new_game

func nextGame(win):
	if not win:
		get_tree().change_scene_to_packed(main_menu)
		return
	current_score += 1
	updateTime()
	var ogTheme = current_theme
	current_game.queue_free()
	current_game = null
	current_theme = null
	var new_game_data = await GameMaster.generateRandomGame()
	current_theme = FoodMaster.food[new_game_data[0]['food'][1]]['theme']
	
	var transition = scene_transition.instantiate()
	add_child(transition)
	transition.transition_done.connect(fadeInGame)
	
	var transition_type = randi_range(1,4)
	while transition_type == prev_transition_type:
		transition_type = randi_range(1,4)
	prev_transition_type = transition_type	
	match transition_type:
		1: transition.initialize("left-right", ogTheme, current_theme)
		2: transition.initialize("right-left", ogTheme, current_theme)
		3: transition.initialize("top-bottom", ogTheme, current_theme)
		4: transition.initialize("bottom-top", ogTheme, current_theme)
	
	current_game = await createGame(new_game_data)

func updateTime():
	if current_score % 5 == 0 and game_time > 5:
		game_time -= 1
		
func fadeInGame():
	current_game.visible = true
	current_game.fadeIn()

func pauseGame():
	var new_menu = pause_menu.instantiate()
	add_child(new_menu)
	get_tree().paused = true
