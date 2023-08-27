extends Control
@onready var task := $margins/gameArea/task
@onready var gameArea := $margins/gameArea
@onready var gameTimer := $gameTimer
@onready var timeBar := $margins/gameArea/timeBar
@onready var current_game = null #current game playing
@onready var current_game_type = null #type of current game
@onready var current_game_info = null
@onready var next_game = null
@onready var next_game_type = null
@onready var next_game_info
@onready var current_task = null #task text for current game
@onready var game_time = 5 #time limit for started game

func _ready():
	timeBar.custom_minimum_size = Vector2(0,size.y/20)
	
	current_game_info = await GameMaster.generateRandomGame()
	theme = load("res://Assets/themes/%sMinigame.tres" % FoodMaster.food[current_game_info[0]['food'][1]]['theme'])
	current_game_type = current_game_info[0]['type']
	current_game = await createGame(current_game_info[0],current_game_info[1], true)
	
	next_game_info = await GameMaster.generateRandomGame()
	next_game_type = next_game_info[0]['type']
	next_game = await createGame(next_game_info[0],next_game_info[1], false)
	
func _process(delta): #
	#if not gameTimer.is_stopped(): #if game timer is counting down
		#timeBar.value = gameTimer.time_left #update time bar value
	pass
	
func createGame(game_data, game_scene, current): #initializes minigame from game data
	
	gameArea.add_child(game_scene) #add new game to game area
	gameArea.move_child(game_scene, 1)
	
	await get_tree().process_frame #await process frame so rects update (weird sizes if we don't wait for expansion, dont like this code)
	await get_tree().process_frame
	game_scene.initialize(game_data) #initialize th 
	if not current:
		game_scene.visible=false
	else:
		updateTask(game_data['task']) #update task label with task text for game
		game_scene.game_win.connect(gameWon) #connect win signal in game to win function
		game_scene.game_loss.connect(reset) #connect loss signal in game to loss function
		match current_game_type: #special game based signals
			"fill_cup": game_scene.over_flow.connect(reset)
			_: pass
	return game_scene
	
func reset():
	clearGame()
	var new_game_info = await GameMaster.generateRandomGame()
	theme = load("res://Assets/themes/%sMinigame.tres" % FoodMaster.food[new_game_info[0]['food'][1]]['theme'])
	print(new_game_info[0]['type'],new_game_info[0])
	#await createGame(new_game_info[0],new_game_info[1])
	pass
	
func clearGame():
	current_game.queue_free()
	current_game = null
	current_game_type = null

func nextGame():
	clearGame()
	current_game = next_game
	current_game_type = next_game_type
	current_game_info = next_game_info
	theme = load("res://Assets/themes/%sMinigame.tres" % FoodMaster.food[current_game_info[0]['food'][1]]['theme'])
	updateTask(current_game_info[0]['task'])
	current_game.visible = true
	current_game.game_win.connect(gameWon) #connect win signal in game to win function
	current_game.game_loss.connect(reset) #connect loss signal in game to loss function
	match current_game_type: #special game based signals
		"fill_cup": current_game.over_flow.connect(reset)
		_: pass
	
	next_game_info = await GameMaster.generateRandomGame()
	next_game_type = next_game_info[0]['type']
	next_game = await createGame(next_game_info[0],next_game_info[1], false)
	
func gameWon():
	print("WON THE GAME")
	nextGame()
	
func updateTask(data):
	task.clear()
	task.parse_bbcode("[center]%s[/center]" % data)
func _on_game_timer_timeout():
	reset()
	pass # Replace with function body.
