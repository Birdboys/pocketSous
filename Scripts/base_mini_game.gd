extends Control
@onready var score := $score
@onready var task := $margins/gameArea/task
@onready var gameArea := $margins/gameArea
@onready var gameTimer := $gameTimer
@onready var timeBar := $margins/gameArea/timeBar
@onready var anim := $gameAnimtor
@onready var current_game = null #current game playing
@onready var current_game_type = null #type of current game
@onready var current_task = null #task text for current game
@onready var score_val #current score
@onready var finished := false
@onready var win
signal game_finished(win)

func _ready():
	timeBar.custom_minimum_size = Vector2(0,size.y/20)
	
func initialize(game_data, timer=false, current_score=null):
	if timer:
		score.visible = true
	else:
		timeBar.modulate.a = 0.0
	if current_score:
		score.parse_bbcode("%s" % str(current_score))
	score_val = current_score
	theme = load("res://Assets/themes/%sMinigame.tres" % FoodMaster.food[game_data[0]['food'][1]]['theme'])
	await createGame(game_data[0],game_data[1])
	return 
func createGame(game_data, game_scene): #initializes minigame from game data
	current_game = game_scene #set current game pointer to instantiated game
	current_game_type = game_data['type'] #set current type to type of game
	updateTask(game_data['task']) #update task label with task text for game
	gameArea.add_child(game_scene) #add new game to game area
	gameArea.move_child(current_game, 1)
	current_game.game_win.connect(gameWon) #connect win signal in game to win function
	current_game.game_loss.connect(gameLost) #connect loss signal in game to loss function
	match current_game_type: #special game based signals
		"fill_cup": current_game.over_flow.connect(gameLost, false)
		_: pass
	await get_tree().process_frame #await process frame so rects update (weird sizes if we don't wait for expansion, dont like this code)
	await get_tree().process_frame
	current_game.initialize(game_data) #initialize th 
	return 

func gameWon():
	if not finished:
		win = true
		finished = true
		anim.play("fade")
		#gameFinished(win)

func gameLost():
	if not finished:
		win = false
		finished = true
		anim.play("fade")
		#gameFinished(win)
		
func updateTask(data):
	task.clear()
	task.parse_bbcode("[center]%s[/center]" % data)
	
func startTimer(time):
	gameTimer.start(time)
	
func _on_game_timer_timeout():
	emit_signal("game_finished", false)
	pass # Replace with function body.

func gameFinished():
	emit_signal("game_finished",win)

func fadeIn():
	anim.play("fade_in")
