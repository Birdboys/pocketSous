extends Node
@onready var game_types := {"select_tap":preload("res://Scenes/select_tap_game.tscn"),
			"collect_tap":preload("res://Scenes/collect_tap_game.tscn"),
			"rapid_tap":preload("res://Scenes/rapid_tap_game.tscn"),
			"single_slice":preload("res://Scenes/single_slice_game.tscn"),
			"radial_slice":preload("res://Scenes/radial_slice_game.tscn"),
			"rotate_food":preload("res://Scenes/rotation_game.tscn"),
			"center_pan":preload("res://Scenes/center_pan_game.tscn"),
			"center_plate":preload("res://Scenes/center_plate_game.tscn"),
			"fill_cup":preload("res://Scenes/fill_cup_game.tscn"),
			"vertical_slice":preload("res://Scenes/single_slice_game.tscn"),
			"horizontal_slice":preload("res://Scenes/single_slice_game.tscn"),
			"dont_burn":preload("res://Scenes/dont_burn_game.tscn"),
			"horizontal_multi_slice":preload("res://Scenes/multi_slice_game.tscn"),
			"vertical_multi_slice":preload("res://Scenes/multi_slice_game.tscn")}
@onready var games = ["collect_tap"]#["collect_tap","rapid_tap","center_plate","horizontal_slice","vertical_slice","radial_slice","fill_cup","dont_burn"]
func getGame(game):
	return game_types[game].instantiate()
	
func generateRandomGame(): #generates data for random game, returns instantiation for game and game data
	print("GENERATING RANDOM GAME")
	var new_game_type = games[randi() % games.size()]
	var game_data #store game data for initialization
	match new_game_type: #get random game data per game type
		#"select_tap": game_data = await getRandomSelectTap()
		"collect_tap": game_data = await getRandomCollectTap()
		"rapid_tap" : game_data = await getRandomRapidTap()
		"center_plate" : game_data = await getRandomCenterPlate()
		"rotate_food" : game_data = await getRandomRotateFood()
		"fill_cup" : game_data = await getRandomFillCup()
		"vertical_slice" : game_data = await getRandomSingleVSlice()
		"horizontal_slice" : game_data = await getRandomSingleHSlice()
		"radial_slice" : game_data = await getRandomRadialSlice()
		"dont_burn" : game_data = await getRandomDontBurn()
		"horizontal_multi_slice": game_data = await getMultiSlice(0)
		"vertical_multi_slice" : game_data = await getMultiSlice(90)
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
	["apple","yellow_apple"],["lime","lime"],["lemon","lemon"],["pork","pork_chop_cooked"],["beef","steak_cooked"]] #centerable foods
	game_data['food'] = center_foods[randi() % center_foods.size()] #select centerable food
	game_data['task'] = "PLATE THE %s" % game_data['food'][1].to_upper() #set task
	return game_data #return game data

func getRandomRotateFood():
	var game_data = {} #game data container
	var rotate_foods = [["apple","red_apple"],["apple","green_apple"],
	["apple","yellow_apple"],["tomato","tomato"],["egg","egg"],["egg","egg_white"],
	["berry","raspberry"],["berry","blueberry"],["berry","blackberry"]] #rotatable foods
	game_data['food'] = rotate_foods[randi() % rotate_foods.size()] #select rotatable food
	game_data['task'] = "ROTATE THE %s" % game_data['food'][1].to_upper() #set task
	return game_data #return game data
	
func getRandomFillCup():
	var game_data = {} #game data container
	var fill_liquids = [["liquid","milk"],["liquid","water"],["liquid","oil"],["liquid","orange_juice"],["liquid","apple_juice"]] #fillable liquids
	var fill_val = randi_range(1,4) #get number of cups to fill from range
	game_data['food'] = fill_liquids[randi() % fill_liquids.size()] #get fillable liquid
	game_data['task'] = "FILL %s CUPS OF %s" % [fill_val,game_data['food'][1].to_upper()] #create task text based on num cups and liquid
	game_data['fill_val'] = fill_val #set fill val in game data
	game_data['color'] = Color(FoodMaster.food[game_data['food'][1]]['main_color']) #Color.hex(0x8bf5c6ff) #get color of liquid - TODO : NOT FINISHED 
	return game_data #return game data

func getRandomSingleHSlice():
	var game_data = {} #game data container
	var cut_foods = [["banana","banana"],["zucchini","zucchini"],["lemon","lemon_vertical"],["lime","lime_vertical"]] #sliceable foods
	game_data['food'] = cut_foods[randi() % cut_foods.size()] #get food
	game_data['task'] = "CUT THE %s" % [game_data['food'][0].to_upper()] #set task based on food
	game_data['cut_type'] = 0 #set cut type to be 0 for horizontal (no rotation)
	return game_data #return game data
	
func getRandomSingleVSlice():
	var game_data = {}
	var cut_foods = [["lemon","lemon"],["lime","lime"],["apple","red_apple"],["apple","green_apple"],
	["apple","yellow_apple"],["pork","pork_chop_raw"],["beef","steak_raw"]]
	game_data['food'] = cut_foods[randi() % cut_foods.size()]
	game_data['task'] = "CUT THE %s" % [game_data['food'][0].to_upper()]
	game_data['cut_type'] = 90 #set cut type to be 90 for vertical (90 degree rotation on instantiated cut)
	return game_data #return game data

func getRandomRadialSlice():
	var game_data = {}
	var cut_foods = [["apple","red_apple"]]
	game_data['food'] = cut_foods[randi() % cut_foods.size()]
	game_data['task'] = "SLICE THE %s" % [game_data['food'][0].to_upper()]
	game_data['num_cut'] = randi_range(2,5) #get number of slices from range
	return game_data #return game data
	
func getRandomDontBurn():
	var game_data = {}
	var cut_foods = [["beef","burger_raw"],["beef","steak_raw"],["pork","pork_chop_raw"]]
	game_data['food'] = cut_foods[randi() % cut_foods.size()]
	game_data['task'] = "DONT BURN THE %s" % [game_data['food'][0].to_upper()]
	game_data['time_scale'] = randi_range(1,4) #get number of slices from range
	return game_data #return game data

func getMultiSlice(type):
	var game_data = {}
	var horizontal_cut_foods = [["banana","banana"],["zucchini","zucchini"], ["lemon","lemon_vertical"],["lime","lime_vertical"]]
	var vertical_cut_foods = [["lemon","lemon"],["apple","red_apple"]]
	if type == 0: game_data['food'] = horizontal_cut_foods[randi() % horizontal_cut_foods.size()]
	else: game_data['food'] = vertical_cut_foods[randi() % vertical_cut_foods.size()]
	game_data['task'] = "SLICE THE %s" % [game_data['food'][0].to_upper()]
	game_data['num_cut'] = randi_range(2,6)
	game_data['cut_type'] = type
	return game_data
