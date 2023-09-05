extends Control
@onready var sliceable := $sliceMargin/sliceable
@onready var slice := preload("res://Scenes/slice.tscn")
@onready var sliceParts := preload("res://Scenes/slice_particles.tscn")
@onready var margin := $sliceMargin
@onready var cuts = []
@onready var offset = 128 #length of collect margin
@export var slice_anim_percent := 1.0
@onready var tween_percent 
@onready var cut_type 
@onready var particle_color
signal game_win
signal game_loss

func _ready():
	setMargins(offset)
	
func _process(_delta):
	sliceable.get_material().set_shader_parameter("percent",slice_anim_percent) #set slice shader params based on animation
	
func initialize(game_data):
	sliceable.texture = load("res://Assets/foods/%s/%s.svg" %[game_data['food'][0],game_data['food'][1]]) #load food sprite
	cut_type = game_data['cut_type']
	particle_color = FoodMaster.food[game_data['food'][1]]['main_color']
	for x in range(game_data['num_cut']):
		var cut = slice.instantiate() #instantaite new slice
		sliceable.add_child(cut) #add to margin
		cut.sliced.connect(cutSliced) #connect sliced event so game can end
		cuts.append(cut)
		#sliceable.get_material().set_shader_parameter("percent",cut_site) #set percent for shader based on cut location
		var min_dim = sliceable.size[sliceable.size.min_axis_index()] #get minimum axis size for calculating cut length
		match game_data['cut_type']: #match for horizontal and vertical slices
			0: cut.initialize(sliceable.size.x/2,  (x+1) * (sliceable.size.y/(game_data['num_cut']+1)),min_dim,0,x);sliceable.get_material().set_shader_parameter("horizontal",true) #instantiate slice - horizontal so dont rotate it - tell shader cut is horizontal
			90: cut.initialize((x+1) * (sliceable.size.x/(game_data['num_cut']+1)), sliceable.size.y/2,min_dim,90,x);sliceable.get_material().set_shader_parameter("horizontal",false) #instantiate slice - horizontal so dont rotate it - tell shader cut is horizontal
		if x > 0:
			cut.visible = false
		tween_percent = 1.0/(game_data['num_cut']+1.0)
		
func cutSliced(s):
	var tween := create_tween()
	tween.tween_property(self, "slice_anim_percent", slice_anim_percent-tween_percent,0.25)
	var new_part = sliceParts.instantiate()
	sliceable.add_child(new_part)
	new_part.position = cuts[s].position
	new_part.color = particle_color
	if cut_type == 90:
		new_part.rotation = -90
	cuts[s] = null
	if cuts.all(func(c): return c == null):
		gameWon()
	else:
		cuts[s+1].visible = true
		
func gameWon():
	cuts = []
	emit_signal("game_win")
	print("WON THE GAME")

func _on_slice_area_gui_input(event):
	#print("ADOSDAODS ADASDA")
	if event.is_action_pressed("screen_touch"):
		print("DRAGGING")
		#$ColorRect.color = "ff75ff3b"
		for cut in cuts:
			if cut:
				cut.inDrag = true

		
	if event.is_action_released("screen_touch"):
		print("ENDING")
		#$ColorRect.color = "43c4fb3b"
		for cut in cuts:
			if cut:
				cut.inDrag = false

func _on_slice_area_mouse_entered():
	if Input.is_action_pressed("screen_touch"):
		#$ColorRect.color = "ff75ff3b"
		for cut in cuts:
			if cut:
				cut.inDrag = true

func _on_slice_area_mouse_exited():
	for cut in cuts:
		if cut:
			cut.inDrag = false

func setMargins(val):
	margin.add_theme_constant_override("margin_top", val) #set margins of collect space
	margin.add_theme_constant_override("margin_left", val)
	margin.add_theme_constant_override("margin_bottom", val)
	margin.add_theme_constant_override("margin_right", val)
