extends Node
@onready var game_types := {"select_tap":preload("res://Scenes/select_tap_game.tscn"),
			"collect_tap":preload("res://Scenes/collect_tap_game.tscn"),
			"rapid_tap":preload("res://Scenes/rapid_tap_game.tscn"),
			"single_slice":preload("res://Scenes/single_slice_game.tscn"),
			"radial_slice":preload("res://Scenes/radial_slice_game.tscn"),
			"rotate_food":preload("res://Scenes/rotation_game.tscn"),
			"center_pan":preload("res://Scenes/center_pan_game.tscn"),
			"center_plate":preload("res://Scenes/center_plate_game.tscn")}
@onready var games = ["center_plate"]#["collect_tap","rapid_tap","center_plate"]

func getGame(game):
	return game_types[game].instantiate()
	
func generateRandomGame(): #generates data for random game, returns instantiation for game and game data
	var new_game_type = games[randi() % games.size()]
	var game_data #store game data for initialization
	match new_game_type: #get random game data per game type
		#"select_tap": game_data = await getRandomSelectTap()
		"collect_tap": game_data = await getRandomCollectTap()
		"rapid_tap" : game_data = await getRandomRapidTap()
		"center_plate" : game_data = await getRandomCenterPlate()
		_: print("HOW'D WE GET HERE") #shouldn't hit, temp
	game_data['type'] = new_game_type #set game data type to randomely selected type
	return [game_data, game_types[new_game_type].instantiate()] #return game data and instantiated mini game
	
func getRandomCollectTap(): #generates game data for collect tap game
	var game_data = {} #game data container
	var collect_foods = [["berry","raspberry"],["berry","blueberry"],["berry","blackberry"],
	["apple","red_apple"],["apple","green_apple"],["apple","yellow_apple"]] #list of collectable foods
	game_data['num_collect'] = randi_range(5,15) #get num collectables generated from range 
	game_data['food'] = collect_foods[randi() % collect_foods.size()] #grab random collectable food
	game_data['task'] = "COLLECT %s %s" % [game_data['num_collect'],game_data['food'][1].to_upper()] #set task based on food name
	return game_data #return game data
	
func getRandomRapidTap():
	var game_data = {} #game data container
	var tap_foods = [["beef","steak_raw"],["pork","pork_chop_raw"]] #list of rapid tapable foods
	game_data['num_tap'] = randf_range(10,25) #get number of taps necessary to complete from range
	game_data['food'] = tap_foods[randi() % tap_foods.size()] #select tapable food
	game_data['task'] = "TENDERIZE THE %s" % game_data['food'][1].to_upper() #set task from food
	return game_data #return game data

func getRandomCenterPlate():
	var game_data = {} #game data container
	var center_foods = [["apple","red_apple"],["apple","green_apple"],
	["apple","yellow_apple"],["lime","lime"],["lemon","lemon"]] #centerable foods
	game_data['food'] = center_foods[randi() % center_foods.size()] #select centerable food
	game_data['task'] = "PLATE THE %s" % game_data['food'][1].to_upper() #set task
	return game_data
