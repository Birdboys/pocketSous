extends Control
@onready var draggable_food := preload("res://Scenes/draggable.tscn") #instantiatable plate food scene
@onready var current_food = null #pointer to plate food
@onready var bowlArea := $margin/bowl/bowlArea
@onready var bowlAreaShape := $margin/bowl/bowlArea/bowlAreaShape
@onready var margin := $margin
@onready var bowl := $margin/bowl
@onready var particleArea := $parts
@onready var bowl_particles := preload("res://Scenes/bowl_particles.tscn")
@onready var offset = 64 #length of collect margin
@onready var food_offset = 64
@onready var foods = []
@onready var num_foods
@onready var food_ratio = 4
signal game_win
signal game_loss

# Called when the node enters the scene tree for the first time.
func _ready():
	setMargins(offset) #set margins
	
func initialize(game_data):
	bowl.texture = load("res://Assets/foods/utensil/%s.svg" % game_data['food'][1])
	bowlArea.position = bowl.size/2
	bowlAreaShape.shape.size = bowl.size/2
	var food_count = 0
	var scale_factor = size[size.min_axis_index()]/food_ratio
	for food in game_data['foods']:
		var new_food = draggable_food.instantiate()
		add_child(new_food)
		foods.append(new_food)
		var new_pos = Vector2(randi_range(food_offset,size.x-food_offset),randi_range(food_offset,size.y-food_offset))
		new_food.placed.connect(foodPlaced)
		new_food.initialize(new_pos, food, scale_factor, "bowl",food_count)
		food_count += 1
	num_foods = food_count
	#move_child(margin, -1)
	
func foodPlaced(id, color):
	var new_parts = bowl_particles.instantiate()
	particleArea.add_child(new_parts)
	new_parts.color = color
	foods[id].queue_free()
	foods[id] = null
	num_foods -= 1
	if num_foods == 0:
		emit_signal("game_win")

func setMargins(val):
	margin.add_theme_constant_override("margin_top", val) #set margins of collect space
	margin.add_theme_constant_override("margin_left", val)
	margin.add_theme_constant_override("margin_bottom", val)
	margin.add_theme_constant_override("margin_right", val)
