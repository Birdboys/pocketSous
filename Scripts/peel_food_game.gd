extends Control
@onready var margin := $margin
@onready var peel := $margin/peel
@onready var food := $margin/food
@onready var anim := $anim
@onready var parts := $margin/food/particleCont
@onready var peelPart := preload("res://Scenes/dice_particles.tscn")
@onready var offset := 64
@onready var particle_color 
@onready var min_swipe_dist := 350.0
@export var finished := false
signal game_win
signal game_loss
func _ready():
	setMargins(offset)
	finished = false

func initialize(game_data):
	food.texture =  load("res://Assets/foods/%s/%s.svg" % [game_data['food'][0], game_data['food'][1]]) #load food
	peel.texture =  load("res://Assets/foods/%s/%s_peel.svg" % [game_data['food'][0], game_data['food'][1]]) #load food
	particle_color = FoodMaster.food[game_data['food'][1]+"_peel"]['main_color']
	$swipeArea.min_swipe_dist = min_swipe_dist
func setMargins(val):
	margin.add_theme_constant_override("margin_top", val) #set margins of cup space
	margin.add_theme_constant_override("margin_left", val)
	margin.add_theme_constant_override("margin_bottom", val)
	margin.add_theme_constant_override("margin_right", val)

func gameWon():
	emit_signal("game_win")
	
func _on_swipe_area_swiped(type, length):
	print(length, finished)
	if not finished:
		print("PEELED")
		anim.play("peeled")
		var new_parts = peelPart.instantiate()
		parts.add_child(new_parts)
		new_parts.color = particle_color
