extends Control
@onready var margin := $margins #margin
@onready var tapper := $margins/tapper #tap food
@onready var post_tap := $margins/post_tap
@onready var tapBar := $tapBar #tap bar for showing progress
@onready var anim := $anim
@onready var partArea := $margins/tapper/partArea
@onready var particle := preload("res://Scenes/bowl_particles.tscn")
@onready var total_taps : int #total taps necessary for completion
@onready var current_taps := 0 #current taps toward completion
@onready var offset = 128 #offset for tapper margin
@onready var tap_bar_ratio = Vector2(20, 5.0/4.0) #ratios for tap bar sizing
@onready var rotation_range = 15 #range of rotation values for food
@onready var particle_color 
@export var finished := false
signal game_win
signal game_loss

func _ready():
	tapper.self_modulate.a = 1.0
	post_tap.modulate.a = 0
	tapBar.visible = true
	finished = false
	setMargins(offset) #set margins

func initialize(game_data):
	tapper.texture = load("res://Assets/foods/%s/%s.svg" % [game_data['food'][0], game_data['food'][1]]) #load food texture
	tapper.pivot_offset = tapper.size/2 #set food pivot offset to be centered
	match game_data['food'][0]:
		"garlic": post_tap.texture = load("res://Assets/foods/garlic/garlic_clove.svg")
		_: post_tap.texture = load("res://Assets/foods/%s/%s.svg" % [game_data['food'][0], game_data['food'][1]]) #load food texture
		
	total_taps = game_data['num_tap'] #set total taps from game data
	tapBar.max_value = total_taps #set tap bar max value
	tapBar.value = 0 #set tap bar progress value to zero
	tapBar.custom_minimum_size = Vector2(size.x/tap_bar_ratio.x,size.y/tap_bar_ratio.y) #update tap bar minimum size with ratios
	particle_color = Color(FoodMaster.food[game_data['food'][1]]['main_color'])
func setMargins(val):
	margin.add_theme_constant_override("margin_top", val) #set margins of collect space
	margin.add_theme_constant_override("margin_left", val)
	margin.add_theme_constant_override("margin_bottom", val)
	margin.add_theme_constant_override("margin_right", val)
	
func gameWon():
	emit_signal("game_win")
	print("WON THE GAME")

func _on_tapper_gui_input(event: InputEvent):
	if event.is_action_pressed("screen_touch"): #if tapper is touched
		current_taps += 1 #increment current taps
		tapBar.value += 1 #increment tap bar vlaue
		if current_taps >= total_taps and not finished: #if we have finished tapping
			anim.play("finished")
			var new_part = particle.instantiate()
			partArea.add_child(new_part)
			new_part.color = particle_color
	
