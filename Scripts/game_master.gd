extends Node
@onready var game_types := {"select_tap":preload("res://Scenes/select_tap_game.tscn"),
			"collect_tap":preload("res://Scenes/collect_tap_game.tscn"),
			"rapid_tap":preload("res://Scenes/rapid_tap_game.tscn"),
			"single_slice":preload("res://Scenes/single_slice_game.tscn"),
			"radial_slice":preload("res://Scenes/radial_slice_game.tscn"),
			"rotate_food":preload("res://Scenes/rotation_game.tscn"),
			"center_pan":preload("res://Scenes/center_pan_game.tscn"),
			"center_plate":preload("res://Scenes/center_pan_game.tscn")}
@onready var select_tap_constants = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getGame(game):
	return game_types[game].instantiate()
	
func generateRandomGame(): #generates data for random game, returns instantiation for game and game data
	var new_game_type = "collect_tap"
	var game_data #store game data for initialization
	match new_game_type: #get random game data per game type
		#"select_tap": game_data = await getRandomSelectTap()
		"collect_tap": game_data = await getRandomCollectTap()
		_: print("HOW'D WE GET HERE") #shouldn't hit, temp
	game_data['type'] = new_game_type #set game data type to randomely selected type
	return [game_data, game_types[new_game_type].instantiate()] #return game data and instantiated mini game
	
func getRandomCollectTap(): #generates game data for collect tap game
	var game_data = {} #game data container
	var collect_foods = [["berry","raspberry"],["berry","blueberry"],["berry","blackberry"],
	["apple","red_apple"],["apple","green_apple"],["apple","yellow_apple"]] #list of collectable foods
	game_data['num_collect'] = randf_range(5,15) #get num collectables generated from range 
	game_data['food'] = collect_foods[randi() % collect_foods.size()] #grab random collectable food
	game_data['task'] = "COLLECT %s" % game_data['food'][1].to_upper() #set task based on food name
	return game_data #return game data

