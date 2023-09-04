extends Control
@onready var draggable_food := preload("res://Scenes/draggable.tscn") #instantiatable plate food scene
@onready var plateArea := $margin/plate/plateArea
@onready var plateAreaShape := $margin/plate/plateArea/plateAreaShape
@onready var margin := $margin
@onready var plate := $margin/plate
@onready var offset = 32 #length of collect margin
@onready var foods = []
@onready var num_foods
@onready var food_ratio = 2
signal game_win
signal game_loss

# Called when the node enters the scene tree for the first time.
func _ready():
	setMargins(offset) #set margins
	
func initialize(game_data):
	plateArea.position = plate.size/2
	plateAreaShape.shape.radius = plate.size[plate.size.min_axis_index()]/4
	var food_count = 0
	var scale_factor = size[size.min_axis_index()]/food_ratio
	for food in game_data['foods']:
		var new_food = draggable_food.instantiate()
		add_child(new_food)
		foods.append(new_food)
		var new_pos = Vector2(randi_range(offset,margin.size.x-offset),randi_range(offset,margin.size.y-offset))
		new_food.placed.connect(foodPlaced)
		new_food.initialize(new_pos, food, scale_factor, "plate",food_count)
		if food_count != 0:
			new_food.visible = false
		food_count += 1
		
	num_foods = food_count
	
func foodPlaced(id, _color):
	print("FOODPLACED")
	foods[id] = null
	num_foods -= 1
	if num_foods == 0:
		emit_signal("game_win")
	else:
		foods[id+1].visible = true

func setMargins(val):
	margin.add_theme_constant_override("margin_top", val) #set margins of collect space
	margin.add_theme_constant_override("margin_left", val)
	margin.add_theme_constant_override("margin_bottom", val)
	margin.add_theme_constant_override("margin_right", val)
