extends Control
@export var slice_anim_percent := 0.0 #used for calculating shader 
@onready var sliceable := $sliceMargin/sliceable
@onready var sliceAnim := $sliceAnim
@onready var slice := preload("res://Scenes/slice.tscn")
@onready var margin := $sliceMargin
@onready var cut #pointer to single cut in game
@onready var offset = 128 #length of collect margin
@onready var sliceParticle := preload("res://Scenes/slice_particles.tscn")
@onready var particle_color
@onready var cut_type 
signal game_win
signal game_loss

func _ready():
	setMargins(offset)
	
func _process(_delta):
	if cut == null:
		sliceable.get_material().set_shader_parameter("cut_time",slice_anim_percent) #set slice shader params based on animation

func initialize(game_data):
	sliceable.texture = load("res://Assets/foods/%s/%s.svg" %[game_data['food'][0],game_data['food'][1]]) #load food sprite
	particle_color = FoodMaster.food[game_data['food'][1]]['main_color']
	cut_type = game_data['cut_type']
	var cut_site = randf_range(0.25,0.75) #get specific area of cut within margin based on range
	cut = slice.instantiate() #instantaite new slice
	sliceable.add_child(cut) #add to margin
	cut.sliced.connect(cutSliced) #connect sliced event so game can end
	sliceable.get_material().set_shader_parameter("percent",cut_site) #set percent for shader based on cut location
	var min_dim = sliceable.size[sliceable.size.min_axis_index()] #get minimum axis size for calculating cut length
	match game_data['cut_type']: #match for horizontal and vertical slices
		0: cut.initialize(sliceable.size.x/2,sliceable.size.y*cut_site,min_dim,0);sliceable.get_material().set_shader_parameter("horizontal",true) #instantiate slice - horizontal so dont rotate it - tell shader cut is horizontal
		90: cut.initialize(sliceable.size.x*cut_site,sliceable.size.y/2,min_dim,90);sliceable.get_material().set_shader_parameter("horizontal",false) #instantiate slice - vertical so rotate 90 - tell shader cut is not horizontal

func cutSliced(_data): #if we slice the cut
	var parts = sliceParticle.instantiate()
	sliceable.add_child(parts)
	parts.position=cut.position
	if cut_type == 90:
		parts.rotation = -90
	parts.color = particle_color
	cut = null #get rid of cut pointer so code doesn't break
	sliceAnim.play("sliced") #play sliced animation to update shader and win game
	
func gameWon():
	emit_signal("game_win")
	print("WON THE GAME")

func _on_slice_area_gui_input(event): #see comments in radial_slice_game
	if event.is_action_pressed("screen_touch"):
		if cut != null:
			cut.inDrag = true
		
	if event.is_action_released("screen_touch"):
		if cut != null:
			cut.inDrag = false

func _on_slice_area_mouse_entered():
	if Input.is_action_pressed("screen_touch"):
		if cut:
			cut.inDrag = true

func _on_slice_area_mouse_exited():
	if cut:
		cut.inDrag = false

func setMargins(val):
	margin.add_theme_constant_override("margin_top", val) #set margins of collect space
	margin.add_theme_constant_override("margin_left", val)
	margin.add_theme_constant_override("margin_bottom", val)
	margin.add_theme_constant_override("margin_right", val)
