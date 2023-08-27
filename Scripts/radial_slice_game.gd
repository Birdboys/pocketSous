extends Control
@onready var sliceable := $sliceMargin/sliceable
@onready var slice := preload("res://Scenes/slice.tscn")
@onready var margin := $sliceMargin
@onready var cuts = [] #keeps track of individual slices
@onready var offset = 128 #length of collect margin
signal game_win
signal game_loss

func _ready():
	setMargins(offset)
	
func initialize(game_data):
	sliceable.texture = load("res://Assets/foods/%s/%s.svg" %[game_data['food'][0],game_data['food'][1]]) #get food from game data
	var start_angle = 0 #angle used for initializing cuts - updated to new angle in for loop
	var angle_offset = 180/game_data['num_cut'] #use number of cuts from game data to calculate degree rotation offset of subsequent cuts
	for x in range(game_data['num_cut']): #create x cuts
		var new_cut = slice.instantiate() #initialize cut
		margin.add_child(new_cut) #add to margin area
		cuts.append(new_cut) #add reference to cuts list 
		new_cut.sliced.connect(sliceSliced) #connect sliced event 
		var min_dim = margin.size[margin.size.min_axis_index()] #get minimum axis size of cut area - used to calculate cut size based on screen size
		new_cut.initialize(margin.size.x/2,margin.size.y/2,min_dim,start_angle,x) #initialize cuts at center of cut margin with rotation and size parameters
		start_angle += angle_offset #add offset to angle variable for next cut

func sliceSliced(s): #when cut is sliced successfully by player - slice index s provided by slice
	cuts[s] = null #set that cut index to null
	if cuts.all(func(c): return c == null): #if we have no cuts
		gameWon() #we won

func gameWon():
	cuts = []
	emit_signal("game_win")

func _on_slice_area_gui_input(event):
	if event.is_action_pressed("screen_touch"): #if we touch cut area
		for cut in cuts: #go through cut list
			if cut: #if uncut
				cut.inDrag = true #set drag to true

	if event.is_action_released("screen_touch"): #if we release touch in cut area
		for cut in cuts: #go through cut list
			if cut: #if uncut
				cut.inDrag = false #set drag to false
	pass # Replace with function body.


func _on_slice_area_mouse_entered(): 
	if Input.is_action_pressed("screen_touch"): #if touch enters mouse area
		for cut in cuts: #go through cut list
			if cut: #if uncut
				cut.inDrag = true #set drag to true


func _on_slice_area_mouse_exited(): #if touch exits cut area
	for cut in cuts: #go through cut list
			if cut: #if uncut
				cut.inDrag = false #set drag to false

func setMargins(val):
	margin.add_theme_constant_override("margin_top", val) #set margins of collect space
	margin.add_theme_constant_override("margin_left", val)
	margin.add_theme_constant_override("margin_bottom", val)
	margin.add_theme_constant_override("margin_right", val)
