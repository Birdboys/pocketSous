extends Control
@onready var score := $score
@onready var task := $margins/gameArea/task
@onready var gameArea := $margins/gameArea
@onready var gameTimer := $gameTimer
@onready var timeBar := $margins/gameArea/timeBar
@onready var current_game = null #current game playing
@onready var current_game_type = null #type of current game
@onready var current_task = null #task text for current game
@onready var score_val = 0 #current score
@onready var game_time = 5 #time limit for started game

func _ready():
	timeBar.custom_minimum_size = Vector2(0,size.y/20)
	score.parse_bbcode("0")
	var new_game_info = await GameMaster.generateRandomGame()
	print(new_game_info[0]['type'],new_game_info[0])
	theme = load("res://Assets/themes/%sMinigame.tres" % FoodMaster.food[new_game_info[0]['food'][1]]['theme'])
	await createGame(new_game_info[0],new_game_info[1])
	pass # Replace with function body.
	
func _process(delta): #
	#if not gameTimer.is_stopped(): #if game timer is counting down
		#timeBar.value = gameTimer.time_left #update time bar value
	pass
	
func createGame(game_data, game_scene): #initializes minigame from game data
	current_game = game_scene #set current game pointer to instantiated game
	current_game_type = game_data['type'] #set current type to type of game
	updateTask(game_data['task']) #update task label with task text for game
	gameArea.add_child(game_scene) #add new game to game area
	gameArea.move_child(current_game, 1)
	current_game.game_win.connect(gameWon) #connect win signal in game to win function
	current_game.game_loss.connect(reset) #connect loss signal in game to loss function
	match current_game_type: #special game based signals
		"fill_cup": current_game.over_flow.connect(reset)
		_: pass
	await get_tree().process_frame #await process frame so rects update (weird sizes if we don't wait for expansion, dont like this code)
	await get_tree().process_frame
	current_game.initialize(game_data) #initialize th 
	return
	
func reset():
	clearGame()
	var new_game_info = await GameMaster.generateRandomGame()
	theme = load("res://Assets/themes/%sMinigame.tres" % FoodMaster.food[new_game_info[0]['food'][1]]['theme'])
	print(new_game_info[0]['type'],new_game_info[0])
	await createGame(new_game_info[0],new_game_info[1])
	pass
	
func clearGame():
	current_game.queue_free()
	current_game = null

func gameWon():
	print("WON THE GAME")
	reset()
	
func updateTask(data):
	task.clear()
	task.parse_bbcode("[center]%s[/center]" % data)
func _on_game_timer_timeout():
	reset()
	pass # Replace with function body.
