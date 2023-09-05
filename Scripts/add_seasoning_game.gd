extends Control
@onready var margin := $margin
@onready var seasoned := $margin/seasoned
@onready var seasoningParticles := preload("res://Scenes/seasoning_particle.tscn")
@onready var offset := 64
@onready var seasonings := []
@onready var season_taps := 0
@onready var seasoning_grad : Gradient
signal game_win
signal game_loss

func _ready():
	setMargins(offset)
	
func initialize(game_data):
	seasoned.texture = load("res://Assets/foods/%s/%s.svg" % [game_data['food'][0],game_data['food'][1]])
	seasonings = game_data['foods']
	season_taps = game_data['season_taps']
	var new_grad := Gradient.new()
	var grad_offset = 1.0/seasonings.size()
	for x in range(seasonings.size()):
		new_grad.add_point(x*grad_offset,Color(FoodMaster.food[seasonings[x]]['main_color']))
	seasoning_grad = new_grad
	
func _on_seasoned_gui_input(_event):
	if Input.is_action_just_pressed("screen_touch") and season_taps > 0:
		season_taps -= 1
		var new_seasoning = seasoningParticles.instantiate()
		add_child(new_seasoning)
		new_seasoning.position = get_local_mouse_position()
		new_seasoning.setGradient(seasoning_grad)
		if season_taps == 0:
			gameWon()
			
func gameWon():
	emit_signal("game_win")
	print("WON THE GAME")

func setMargins(val):
	margin.add_theme_constant_override("margin_top", val) #set margins of collect space
	margin.add_theme_constant_override("margin_left", val)
	margin.add_theme_constant_override("margin_bottom", val)
	margin.add_theme_constant_override("margin_right", val)
