extends Control
@onready var margin := $margin
@onready var anim := $anim
@onready var food := $margin/food
@onready var food_diced := $margin/food_diced
@onready var parts_area := $margin/food/parts
@onready var diceParts := preload("res://Scenes/dice_particles.tscn")
@onready var offset = 128 #offset for tapper margin
@onready var num_swipe := 0.0
@onready var current_swipe := 0.0
@onready var part_color
@export var finished := false
signal game_win 
signal game_loss
# Called when the node enters the scene tree for the first time.
func _ready():
	finished = false
	setMargins(offset)
	food.get_material().set_shader_parameter("dice_percent", 0.0) 
	food_diced.get_material().set_shader_parameter("color", Color.WHITE) 
	food_diced.modulate.a = 0.0
func initialize(game_data):
	food.texture = load("res://Assets/foods/%s/%s.svg" %[game_data['food'][0],game_data['food'][1]]) #load food sprite
	match game_data['food'][1]:
		"cheddar":
			food_diced.texture = load('res://Assets/foods/prepared/sliced.svg')
		_: 
			food_diced.texture = load('res://Assets/foods/prepared/diced.svg')
	food_diced.get_material().set_shader_parameter("color",Color(FoodMaster.food[game_data['food'][1]]['main_color']))
	food_diced.get_material().set_shader_parameter("set_color",true)
	num_swipe = game_data['num_swipe']
	part_color =  FoodMaster.food[game_data['food'][1]]['main_color']
	
func setMargins(val):
	margin.add_theme_constant_override("margin_top", val) #set margins of cup space
	margin.add_theme_constant_override("margin_left", val)
	margin.add_theme_constant_override("margin_bottom", val)
	margin.add_theme_constant_override("margin_right", val)
	
func _on_swipe_area_swiped(type, length):
	print("SWIPED")
	if not finished:
		current_swipe += 1.0
		food.get_material().set_shader_parameter("dice_percent", 1.0/num_swipe*current_swipe) 
		var new_parts = diceParts.instantiate()
		parts_area.add_child(new_parts)
		new_parts.color = part_color
		if current_swipe == num_swipe:
			diceFinished()

func diceFinished():
	if not finished:
		anim.play("finished")

func gameWon():
	emit_signal("game_win")
