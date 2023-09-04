extends Control
@onready var margin := $margin
@onready var bread := $margin/bread
@onready var spread := $margin/spread
@onready var anim := $AnimationPlayer
@onready var offset = 128 #length of collect margin
@onready var spreads = []
@onready var num_spreads := 0
@onready var current_spread := 0
@onready var og_color := Color.TRANSPARENT
@onready var new_color : Color
@onready var finished := false
@export var spread_percent := 0.0
signal game_win
signal game_loss

func _ready():
	setMargins(offset)
	spread.get_material().set_shader_parameter("og_color",og_color) 
	spread.get_material().set_shader_parameter("percent",0.0) 
	set_process(false)
	
func _process(_delta):
	spread.get_material().set_shader_parameter("percent",spread_percent) 
	
func initialize(game_data):
	bread.texture = load("res://Assets/foods/bread/%s.svg" % game_data['food'][1])
	spread.texture = load("res://Assets/foods/bread/%s_spread.svg" % game_data['food'][1])
	spreads = game_data['foods']
	num_spreads = spreads.size()
	new_color = Color(FoodMaster.food[spreads[0]]['main_color'])
	spread.get_material().set_shader_parameter("new_color",new_color) 

func nextSpread():
	spreads[current_spread] = null
	current_spread += 1
	if current_spread == num_spreads:
		gameWon()
	else:
		og_color = new_color
		new_color = Color(FoodMaster.food[spreads[current_spread]]['main_color'])
		spread.get_material().set_shader_parameter("og_color",og_color) 
		spread.get_material().set_shader_parameter("new_color",new_color)
		spread.get_material().set_shader_parameter("percent",0.0) 
	set_process(false)
	
func gameWon():
	finished = true
	emit_signal("game_win")
	print("WON THE GAME")

func setMargins(val):
	margin.add_theme_constant_override("margin_top", val) #set margins of collect space
	margin.add_theme_constant_override("margin_left", val)
	margin.add_theme_constant_override("margin_bottom", val)
	margin.add_theme_constant_override("margin_right", val)
	
func _on_bread_gui_input(event):
	if not finished:
		if Input.is_action_just_pressed("screen_touch") and not anim.is_playing():
			anim.play("spread")
			print("STARTING SPREAD")
		
