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
			"vertical_multi_slice":preload("res://Scenes/multi_slice_game.tscn"),
			"food_bowl":preload("res://Scenes/food_bowl_game.tscn"),
			"plate_food":preload("res://Scenes/plate_food_game.tscn"),
			"bread_spread":preload("res://Scenes/bread_spread_game.tscn"),
			"add_seasoning":preload("res://Scenes/add_seasoning_game.tscn"),
			"dice_food":preload("res://Scenes/dice_food_game.tscn"),
			"peel_food":preload("res://Scenes/peel_food_game.tscn")}
@onready var games = ["dice_food"]#["rotate_food","collect_tap","rapid_tap","center_plate","horizontal_slice","vertical_slice","radial_slice","fill_cup","dont_burn","vertical_multi_slice","horizontal_multi_slice","plate_food","add_seasoning","bread_spread","peel_food"]
func getGame(game):
	return game_types[game]
	
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
		"food_bowl" : game_data = await getRandomFoodBowl()
		"plate_food" : game_data = await getRandomPlateFood()
		"bread_spread" : game_data = await getRandomBreadSpread()
		"add_seasoning" : game_data = await getRandomAddSeasoning()
		"dice_food" : game_data = await getRandomDiceFood()
		"peel_food" : game_data = await getRandomPeelFood()
		_: print("HOW'D WE GET HERE") #shouldn't hit, temp
	game_data['type'] = new_game_type #set game data type to randomely selected type
	game_data['color'] = Color(FoodMaster.food[game_data['food'][1]]['main_color']) 
	return [game_data, game_types[new_game_type].instantiate()] #return game data and instantiated mini game
	
func getRandomCollectTap(): #generates game data for collect tap game
	var game_data = {} #game data container
	var collect_foods = [["berry","raspberry"],["berry","blueberry"],["berry","blackberry"],
	["apple","red_apple"],["apple","green_apple"],["apple","yellow_apple"]] #list of collectable foods
	game_data['num_collect'] = randi_range(5,15) #get num collectables generated from range 
	game_data['food'] = collect_foods[randi() % collect_foods.size()] #grab random collectable food
	game_data['task'] = (tr("COLLECT_TASK") % tr(FoodMaster.food[game_data['food'][1]]['name'])).to_upper()
	game_data['bg'] = 'checkered'
	return game_data #return game data
	
func getRandomRapidTap():
	var game_data = {} #game data container
	var tap_foods = [["pork","pork_chop_raw"],["garlic","garlic"]]#[["beef","steak_raw"],["pork","pork_chop_raw"],["garlic","garlic"]] #list of rapid tapable foods
	game_data['num_tap'] = randi_range(10,25) #get number of taps necessary to complete from range
	game_data['food'] = tap_foods[randi() % tap_foods.size()] #select tapable food
	game_data['task'] = (tr("RAPID_TAP_TASK_%s" % game_data['food'][1])).to_upper()
	game_data['bg'] = 'diamonds'
	return game_data #return game data

func getRandomCenterPlate():
	var game_data = {} #game data container
	var center_foods = [["apple","red_apple"],["apple","green_apple"],
	["apple","yellow_apple"],["lime","lime"],["lemon","lemon"],["pork","pork_chop_cooked"],["beef","steak_cooked"]] #centerable foods
	game_data['food'] = center_foods[randi() % center_foods.size()] #select centerable food
	game_data['task'] = (tr("CENTER_PLATE_TASK") % tr(FoodMaster.food[game_data['food'][1]]['name'])).to_upper()
	game_data['bg'] = 'circles'
	return game_data #return game data

func getRandomRotateFood():
	var game_data = {} #game data container
	var rotate_foods = [["apple","red_apple"],["apple","green_apple"],
	["apple","yellow_apple"],["egg","egg"],["egg","egg_white"],
	["berry","raspberry"],["berry","blueberry"],["berry","blackberry"]] #rotatable foods
	game_data['food'] = rotate_foods[randi() % rotate_foods.size()] #select rotatable food
	game_data['task'] = (tr("ROTATE_TASK") % tr(FoodMaster.food[game_data['food'][1]]['name'])).to_upper()
	game_data['bg'] = 'diagonals'
	return game_data #return game data
	
func getRandomFillCup():
	var game_data = {} #game data container
	var fill_liquids = [["liquid","milk"],["liquid","water"],["liquid","oil"],["liquid","orange_juice"],["liquid","apple_juice"],["liquid","broth"],["rice","white_rice"],["rice","brown_rice"]] #fillable liquids
	var fill_val = randi_range(1,4) #get number of cups to fill from range
	game_data['food'] = fill_liquids[randi() % fill_liquids.size()] #get fillable liquid
	game_data['task'] = (tr("FILL_CUP_TASK") % [fill_val, tr(FoodMaster.food[game_data['food'][1]]['name'])]).to_upper()
	game_data['fill_val'] = fill_val #set fill val in game data
	game_data['bg'] = 'circles'
	return game_data #return game data

func getRandomSingleHSlice():
	var game_data = {} #game data container
	var cut_foods = [["banana","banana"],["zucchini","zucchini"],["lemon","lemon_vertical"],["lime","lime_vertical"]] #sliceable foods
	game_data['food'] = cut_foods[randi() % cut_foods.size()] #get food
	game_data['task'] = (tr("SLICE_TASK") % tr(FoodMaster.food[game_data['food'][1]]['name'])).to_upper()
	game_data['cut_type'] = 0 #set cut type to be 0 for horizontal (no rotation)
	game_data['bg'] = 'hstripes'
	return game_data #return game data
	
func getRandomSingleVSlice():
	var game_data = {}
	var cut_foods = [["lemon","lemon"],["lime","lime"],["apple","red_apple"],["apple","green_apple"],
	["apple","yellow_apple"],["pork","pork_chop_raw"],["beef","steak_raw"]]
	game_data['food'] = cut_foods[randi() % cut_foods.size()]
	game_data['task'] = (tr("SLICE_TASK") % tr(FoodMaster.food[game_data['food'][1]]['name'])).to_upper()
	game_data['cut_type'] = 90 #set cut type to be 90 for vertical (90 degree rotation on instantiated cut)
	game_data['bg'] = 'vstripes'
	return game_data #return game data

func getRandomRadialSlice():
	var game_data = {}
	var cut_foods = [["apple","red_apple"]]
	game_data['food'] = cut_foods[randi() % cut_foods.size()]
	game_data['task'] = (tr("RADIAL_SLICE_TASK") % tr(FoodMaster.food[game_data['food'][1]]['name'])).to_upper()
	game_data['num_cut'] = randi_range(2,5) #get number of slices from range
	game_data['bg'] = 'squares'
	return game_data #return game data
	
func getRandomDontBurn():
	var game_data = {}
	var cut_foods = [["beef","burger_raw"],["beef","steak_raw"],["pork","pork_chop_raw"]]
	game_data['food'] = cut_foods[randi() % cut_foods.size()]
	game_data['task'] = "DONT BURN THE %s" % [game_data['food'][0].to_upper()]
	game_data['time_scale'] = randi_range(1,4) #get number of slices from range
	game_data['bg'] = 'squares'
	return game_data #return game data

func getMultiSlice(type):
	var game_data = {}
	var horizontal_cut_foods = [["banana","banana"],["zucchini","zucchini"], ["lemon","lemon_vertical"],["lime","lime_vertical"]]
	var vertical_cut_foods = [["bread","bread_loaf"]]#[["lemon","lemon"],["apple","red_apple"]]
	if type == 0: game_data['food'] = horizontal_cut_foods[randi() % horizontal_cut_foods.size()]
	else: game_data['food'] = vertical_cut_foods[randi() % vertical_cut_foods.size()]
	game_data['task'] = (tr("MULTI_SLICE_TASK") % tr(FoodMaster.food[game_data['food'][1]]['name'])).to_upper()
	game_data['num_cut'] = randi_range(2,6)
	game_data['cut_type'] = type
	game_data['bg'] = 'diamonds'
	return game_data

func getRandomFoodBowl():
	var game_data = {}
	var foods = [["egg","egg"],["egg","egg_white"],
	["berry","raspberry"],["berry","blueberry"],["berry","blackberry"]]
	var utensils = [["utensil","bowl"],["utensil","blender"]]
	var num_foods = randi_range(4,8)
	game_data['food'] = utensils[randi() % utensils.size()]
	game_data['foods'] = []
	for x in range(0,num_foods):
		game_data['foods'].append(foods[randi() % foods.size()])
	game_data['task'] = "GATHER FOOD"
	game_data['bg'] = 'checkered'
	return game_data

func getRandomPlateFood():
	var game_data = {}
	var foods = [["beef","burger_raw"],["beef","steak_raw"],["pork","pork_chop_raw"],
	["berry","raspberry"],["berry","blueberry"],["berry","blackberry"]]
	var num_foods = randi_range(1,4)
	game_data['food'] = ["utensil","plate"]
	game_data['foods'] = []
	for x in range(0,num_foods):
		game_data['foods'].append(foods[randi() % foods.size()])
	game_data['task'] = "PLATE FOOD"
	game_data['bg'] = 'circles'
	return game_data

func getRandomBreadSpread():
	var game_data = {}
	var breads = [["bread","bread_slice"],["bread","bun_bottom"]]
	var spreads = ["peanut_butter","jelly_strawberry","jelly_blueberry","jelly_grape","ketchup","mayo","mustard","relish","hot_sauce","butter_spread"]
	var spread_choice = spreads[randi() % spreads.size()]
	game_data['food'] = breads[randi() % breads.size()]
	game_data['foods'] = [spread_choice]
	game_data['task'] = 'SPREAD %s' % spread_choice
	game_data['bg'] = 'checkered'
	return game_data

func getRandomAddSeasoning():
	var game_data = {}
	var seasoned = [["beef","steak_raw"],["pork","pork_chop_raw"],["beef","burger_raw"]]
	var seasonings = ["cayenne","chili","cinnamon","thyme","oregano","paprika","cumin"]
	var num_seasoning = randi_range(2,6)
	game_data['food'] = seasoned[randi() % seasoned.size()]
	game_data['foods'] = ["salt","pepper"]
	game_data['season_taps'] = randi_range(5,10)
	for x in range(num_seasoning-2):
		game_data['foods'].append(seasonings.pop_at(randi() % seasonings.size()))
	game_data['task'] = 'SEASON %s' % game_data['food'][1]
	game_data['bg'] = 'circles'
	return game_data

func getRandomDiceFood():
	var game_data = {}
	var foods = [["carrot","carrot"],["onion","onion_yellow_half"],["onion","onion_red_half"],["beef","steak_raw"]]
	game_data['food'] = foods[randi() % foods.size()]
	game_data['num_swipe'] = randi_range(5,10)
	game_data['task'] = 'DICE %s' % game_data['food'][1]
	game_data['bg'] = 'diamonds'
	return game_data

func getRandomPeelFood():
	var game_data = {}
	var foods = [["corn","corn"]]
	game_data['food'] = foods[randi() % foods.size()]
	game_data['task'] = 'PEEL %s' % game_data['food'][1]
	game_data['bg'] = 'checkered'
	return game_data
