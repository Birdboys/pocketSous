extends Control
@onready var score := $score
@onready var task := $margins/gameArea/task
@onready var gameArea := $margins/gameArea
@onready var gameTimer := $gameTimer
@onready var timeBar := $timeBar
@onready var game_data_1 = {"type":"select_tap","theme":"blue","task_text":"TAKE GOOD EGGS","num_tap":6,"num_col":2,"num_bad_tap":2,"good_tap":[["egg","egg"],["egg","egg_white"]],"bad_tap":[["egg","egg_crack"],["egg","egg_crack_white"]]}
@onready var game_data_2 = {"type":"select_tap","theme":"tan","task_text":"TAKE GOOD TOMATOES","num_tap":9,"num_col":3,"num_bad_tap":4,"good_tap":[["tomato","tomato"]],"bad_tap":[["tomato","tomato_bad"]]}
@onready var game_data_3 = {"type":"collect_tap","theme":"pink","task_text":"COLLECT BLUEBERRIES","num_collect":10,"good_collect":[["berry","blueberry"]],"bad_collect":[]}
@onready var games = [game_data_1,game_data_2,game_data_3]
@onready var selectTapMiniGame := preload("res://Scenes/select_tap_game.tscn")
@onready var collectTapMiniGame := preload("res://Scenes/collect_tap_game.tscn")
@onready var current_game = null
@onready var score_val = 0
@onready var game_time = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	score.parse_bbcode("0")
	generateGame(games[randi() % games.size()])
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeBar.value = gameTimer.time_left
	pass

func generateGame(game_data):
	theme = load("res://Assets/themes/%sMinigame.tres" % game_data['theme'])
	gameTimer.start(game_time)
	timeBar.max_value = game_time
	match game_data['type']:
		'select_tap': generateSelectTapGame(game_data)
		'collect_tap': generateCollectTapGame(game_data)
		
func generateSelectTapGame(game_data):
	task.parse_bbcode("[center]"+game_data["task_text"]+"[/center]")
	current_game = selectTapMiniGame.instantiate()
	gameArea.add_child(current_game)
	current_game.game_win.connect(gameWon)
	current_game.game_loss.connect(reset)
	current_game.initialize(game_data['num_tap'],game_data['num_col'],game_data['num_bad_tap'],game_data['good_tap'],game_data['bad_tap'])
	pass

func generateCollectTapGame(game_data):
	task.parse_bbcode("[center]"+game_data["task_text"]+"[/center]")
	current_game = collectTapMiniGame.instantiate()
	gameArea.add_child(current_game)
	current_game.game_win.connect(gameWon)
	current_game.game_loss.connect(reset)
	await current_game.resized
	await current_game.resized
	current_game.initialize(game_data['num_collect'],game_data['good_collect'])
	
func reset():
	clearGame()
	generateGame(games[randi() % games.size()])
	pass
	
func clearGame():
	current_game.queue_free()
	current_game = null

func gameWon():
	score_val += 1
	score.parse_bbcode(str(score_val))
	reset()

func _on_game_timer_timeout():
	reset()
	pass # Replace with function body.
