extends Control
@onready var current_game = null
@onready var current_theme = null
@onready var next_game = null
@onready var mini_game = preload("res://Scenes/base_mini_game.tscn")
@onready var scene_transition = preload("res://Scenes/scene_transition.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	current_game = await createGame()
	current_game.fadeIn()
	pass # Replace with function body.
	
func createGame():
	var new_game = mini_game.instantiate()
	add_child(new_game)
	move_child(new_game, 0)
	var game_data = await GameMaster.generateRandomGame()
	current_theme = FoodMaster.food[game_data[0]['food'][1]]['theme']
	new_game.initialize(game_data)
	new_game.game_finished.connect(nextGame)
	return new_game

func nextGame(win):
	var transition = scene_transition.instantiate()
	var ogTheme = current_theme
	var new_game = await createGame()
	var newTheme = current_theme
	add_child(transition)
	transition.transition_done.connect(fadeInGame)
	
	var transition_type = randi_range(1,4)
	match transition_type:
		1: transition.initialize("left-right", ogTheme, newTheme)
		2: transition.initialize("right-left", ogTheme, newTheme)
		3: transition.initialize("top-bottom", ogTheme, newTheme)
		4: transition.initialize("bottom-top", ogTheme, newTheme)
	current_game.queue_free()
	current_game = new_game
	current_game.visible = false
	
func fadeInGame():
	current_game.visible = true
	current_game.fadeIn()
	
