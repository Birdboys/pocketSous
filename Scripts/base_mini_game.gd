extends Control
@onready var score := $score
@onready var task := $margins/gameArea/task
@onready var gameArea := $margins/gameArea
@onready var gameTimer := $gameTimer
@onready var timeBar := $timeBar
@onready var game_data_1 = {"type":"select_tap","theme":"blue","task_text":"TAKE GOOD EGGS","num_tap":12,"num_col":3,"num_bad_tap":3,"good_tap":[["egg","egg"],["egg","egg_white"]],"bad_tap":[["egg","egg_crack"],["egg","egg_crack_white"]]}
@onready var game_data_2 = {"type":"select_tap","theme":"tan","task_text":"TAKE GOOD TOMATOES","num_tap":6,"num_col":2,"num_bad_tap":2,"good_tap":[["tomato","tomato"]],"bad_tap":[["tomato","tomato_bad"]]}
@onready var game_data_3 = {"type":"collect_tap","theme":"pink","task_text":"COLLECT %s BLUEBERRY","num_collect":10,"good_collect":[["berry","blueberry"]],"bad_collect":[]}
@onready var game_data_4 = {"type":"single_slice","theme":"orange","task_text":"SLICE THE ZUCCHINI","food":["zucchini","zucchini"],"cut":0}
@onready var game_data_5 = {"type":"single_slice","theme":"blue","task_text":"SLICE THE BANANA","food":["banana","banana"], "cut":0}
@onready var game_data_6 = {"type":"single_slice","theme":"lightGreen","task_text":"SLICE THE APPLE","food":["apple","red_apple"], "cut":90}
@onready var game_data_7 = {"type":"single_slice","theme":"tan","task_text":"SLICE THE APPLE","food":["apple","green_apple"], "cut":90}
@onready var game_data_8 = {"type":"center_plate_food","theme":"blue","task_text":"PLATE THE TOMATO","food":["tomato","tomato"]}
@onready var game_data_9 = {"type":"single_slice","theme":"blue","task_text":"SLICE THE LEMON","food":["lemon","lemon"], "cut":0}
@onready var game_data_10 = {"type":"single_slice","theme":"pink","task_text":"SLICE THE LIME","food":["lime","lime"], "cut":0}
@onready var game_data_11 = {"type":"single_slice","theme":"blue","task_text":"SLICE THE LEMON","food":["lemon","lemon"], "cut":90}
@onready var game_data_12 = {"type":"single_slice","theme":"pink","task_text":"SLICE THE LIME","food":["lime","lime"], "cut":90}
@onready var game_data_13 = {"type":"radial_slice","theme":"lightGreen","task_text":"SLICE THE APPLE","food":["apple","red_apple"], "cut":3}
@onready var game_data_14 = {"type":"radial_slice","theme":"lightGray","task_text":"SLICE THE APPLE","food":["apple","yellow_apple"], "cut":2}
@onready var game_data_15 = {"type":"collect_tap","theme":"yellow","task_text":"COLLECT %s BLACKBERRY","num_collect":10,"good_collect":[["berry","blackberry"]],"bad_collect":[]}
@onready var game_data_16 = {"type":"collect_tap","theme":"darkBlue","task_text":"COLLECT %s RASPBERRY","num_collect":10,"good_collect":[["berry","raspberry"]],"bad_collect":[]}
@onready var game_data_17 = {"type":"rotate_food","theme":"darkBlue","task_text":"ROTATE THE APPLE","food":["apple","yellow_apple"]}
@onready var game_data_18 = {"type":"rotate_food","theme":"yellow","task_text":"ROTATE THE RASPBERRY","food":["berry","raspberry"]}
@onready var game_data_19 = {"type":"rapid_tap","theme":"darkBlue","task_text":"TENDERIZE THE CHICKEN","num_tap":30,"food":["pork","pork_chop_raw"]}
@onready var game_data_20 = {"type":"rapid_tap","theme":"blue","task_text":"TENDERIZE THE STEAK","num_tap":15,"food":["beef","steak_raw"]}
@onready var games = [game_data_1,game_data_2,game_data_3,game_data_4,game_data_5,game_data_6,game_data_7,game_data_8,game_data_9,game_data_10,game_data_11,game_data_12,game_data_13,game_data_14,game_data_15,game_data_16,game_data_17,game_data_18]
@onready var selectTapMiniGame := preload("res://Scenes/select_tap_game.tscn")
@onready var collectTapMiniGame := preload("res://Scenes/collect_tap_game.tscn")
@onready var singleSwipeMiniGame := preload("res://Scenes/single_slice_game.tscn")
@onready var centerPlateFoodMiniGame := preload("res://Scenes/center_plate_game.tscn")
@onready var radialSliceMiniGame := preload("res://Scenes/radial_slice_game.tscn")
@onready var rotateFoodMiniGame := preload("res://Scenes/rotation_game.tscn")
@onready var rapidTapFoodMiniGame := preload("res://Scenes/rapid_tap_game.tscn")
@onready var current_game = null
@onready var current_game_type = null
@onready var current_task = null
@onready var score_val = 0
@onready var game_time = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	timeBar.custom_minimum_size = Vector2(0,size.y/20)
	task.clear()
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
	current_game_type = game_data['type']
	current_task = game_data["task_text"]
	match game_data['type']:
		'select_tap': generateSelectTapGame(game_data)
		'collect_tap': generateCollectTapGame(game_data)
		'single_slice': generateSingleSwipeGame(game_data)
		'center_plate_food': generateCenterPlateFoodGame(game_data)
		'radial_slice': generateRadialSliceGame(game_data)
		'rotate_food': rotateFoodGame(game_data)
		'rapid_tap': rapidTapGame(game_data)
func generateSelectTapGame(game_data):
	updateTask()
	current_game = selectTapMiniGame.instantiate()
	gameArea.add_child(current_game)
	current_game.game_win.connect(gameWon)
	current_game.game_loss.connect(reset)
	await get_tree().process_frame
	await get_tree().process_frame
	current_game.initialize(game_data['num_tap'],game_data['num_col'],game_data['num_bad_tap'],game_data['good_tap'],game_data['bad_tap'])
	pass

func generateCollectTapGame(game_data):
	updateTask(game_data['num_collect'])
	current_game = collectTapMiniGame.instantiate()
	gameArea.add_child(current_game)
	current_game.game_win.connect(gameWon)
	current_game.game_loss.connect(reset)
	current_game.collected.connect(updateTask)
	await get_tree().process_frame
	await get_tree().process_frame
	current_game.initialize(game_data['num_collect'],game_data['good_collect'])
	
func generateSingleSwipeGame(game_data):
	updateTask()
	current_game = singleSwipeMiniGame.instantiate()
	gameArea.add_child(current_game)
	current_game.game_win.connect(gameWon)
	current_game.game_loss.connect(reset)
	await get_tree().process_frame
	current_game.initialize(game_data['food'], game_data['cut'])
	
func generateCenterPlateFoodGame(game_data):
	updateTask()
	current_game = centerPlateFoodMiniGame.instantiate()
	gameArea.add_child(current_game)
	current_game.game_win.connect(gameWon)
	current_game.game_loss.connect(reset)
	await get_tree().process_frame
	current_game.initialize(game_data['food'])
	
func generateRadialSliceGame(game_data):
	updateTask()
	current_game = radialSliceMiniGame.instantiate()
	gameArea.add_child(current_game)
	current_game.game_win.connect(gameWon)
	current_game.game_loss.connect(reset)
	await get_tree().process_frame
	current_game.initialize(game_data['food'], game_data['cut'])

func rotateFoodGame(game_data):
	updateTask()
	current_game = rotateFoodMiniGame.instantiate()
	gameArea.add_child(current_game)
	current_game.game_win.connect(gameWon)
	current_game.game_loss.connect(reset)
	await get_tree().process_frame
	current_game.initialize(game_data['food'])
	
func rapidTapGame(game_data):
	updateTask()
	current_game = rapidTapFoodMiniGame.instantiate()
	gameArea.add_child(current_game)
	current_game.game_win.connect(gameWon)
	current_game.game_loss.connect(reset)
	await get_tree().process_frame
	current_game.initialize(game_data['food'], game_data['num_tap'])
	
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
	
func updateTask(data=null):
	match current_game_type:
		"collect_tap": var nt = "[center]"+current_task+"[/center]";task.clear();task.parse_bbcode(nt % str(data))
		_: task.parse_bbcode("[center]"+current_task+"[/center]")
		
func _on_game_timer_timeout():
	reset()
	pass # Replace with function body.
