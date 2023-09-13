extends Control
@onready var task := $margins/gameArea/task
@onready var gameArea := $margins/gameArea
@onready var gameTimer := $gameTimer
@onready var timeBar := $margins/gameArea/timeBar
@onready var anim := $gameAnimtor
@onready var bgShader := $backgroundColor/backgroundShader
@onready var margin := $margins
@onready var shadowShader := preload("res://Scenes/shadow_shader.tscn")
@onready var current_game = null #current game playing
@onready var current_game_type = null #type of current game
@onready var current_task = null #task text for current game
@onready var score_val #current score
@export var shadow_shader : ColorRect
@onready var finished := false
@onready var paused := false
@onready var win
@onready var is_timed := false
@onready var game_time := 0.0
@onready var backgrounds = ["squares_tile","circles_tile","hstripes_tile","vstripes_tile","diamonds_tile","diagonals_tile"]
signal game_finished(win)
signal pause

func _ready():
	timeBar.custom_minimum_size = Vector2(0,size.y/20)
	margin.modulate.a = 0
	bgShader.modulate.a = 0
	
func _process(_delta):
	if is_timed:
		timeBar.value = float((gameTimer.time_left/game_time) * 100)
		
func initialize(game_data, time=null, current_score=null):
	if time != null:
		is_timed = true
		game_time = time
	else:
		timeBar.modulate.a = 0.0
	score_val = current_score
	theme = load("res://Assets/themes/%sMinigame.tres" % FoodMaster.food[game_data[0]['food'][1]]['theme'])
	var new_shader = shadowShader.instantiate()
	var background_color = theme.get_stylebox("panel","bg").bg_color
	var shadow_color = theme.get_color("default_color","scoreLabel")
	print(background_color, shadow_color, shadow_color.blend(background_color))
	new_shader.get_material().set_shader_parameter("background_color",background_color)
	new_shader.get_material().set_shader_parameter("shadow_color",shadow_color)
	new_shader.get_material().set_shader_parameter("shadow_on_background_color",background_color.blend(shadow_color))
	shadow_shader = new_shader
	bgShader.get_material().set_shader_parameter("color",theme.get_color("default_color","scoreLabel"))
	bgShader.get_material().set_shader_parameter("bg",load("res://Assets/backgrounds/%s_tile.svg" % game_data[0]['bg']))
	await createGame(game_data[0],game_data[1])
	current_game.add_child(new_shader)
	return 
	
func createGame(game_data, game_scene): #initializes minigame from game data
	current_game = game_scene #set current game pointer to instantiated game
	current_game_type = game_data['type'] #set current type to type of game
	updateTask(game_data['task']) #update task label with task text for game
	gameArea.add_child(current_game) #add new game to game area
	gameArea.move_child(current_game, 1)
	current_game.game_win.connect(gameWon) #connect win signal in game to win function
	current_game.game_loss.connect(gameLost) #connect loss signal in game to loss function
	match current_game_type: #special game based signals
		"fill_cup": current_game.over_flow.connect(gameLost, false)
		_: pass
	await get_tree().process_frame #await process frame so rects update (weird sizes if we don't wait for expansion, dont like this code)
	await get_tree().process_frame
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
	
func startTimer():
	if is_timed:
		gameTimer.start(game_time)
	match current_game_type:
		"dont_burn": current_game.startCooking()
		_: pass
	
func _on_game_timer_timeout():
	if not finished:
		finished = true
		gameLost()
	pass # Replace with function body.

func gameFinished(): 
	emit_signal("game_finished",win)

func fadeIn():
	anim.play("fade_in")
	
func _on_task_gui_input(_event):
	if Input.is_action_just_pressed("screen_touch"):# and not paused:
		emit_signal("pause")

func turnOffShadow():
	shadow_shader.visible = false

func turnOnShadow():
	shadow_shader.visible = true
