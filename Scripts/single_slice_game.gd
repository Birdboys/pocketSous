extends Control
@export var slice_anim_percent := 0.0
@onready var sliceable := $sliceMargin/sliceable
@onready var sliceAnim := $sliceAnim
@onready var slice := preload("res://Scenes/slice.tscn")
@onready var margin := $sliceMargin
@onready var cut
@onready var offset = 128 #length of collect margin
signal game_win
signal game_loss
func _ready():
	setMargins(offset)
	
func _process(delta):
	if cut == null:
		#print(slice_anim_percent)
		sliceable.get_material().set_shader_parameter("cut_time",slice_anim_percent)
	#print(sliceable.get_material().get_shader_parameter("cut_time"))
	#print(sliceable.get_material().get_shader_parameter("percent"))
func initialize(game_data):
	sliceable.texture = load("res://Assets/foods/%s/%s.svg" %[game_data['food'][0],game_data['food'][1]])
	var cut_range = margin.size
	await get_tree().process_frame
	
	var cut_site = randf_range(0.25,0.75)
	cut = slice.instantiate()
	margin.add_child(cut)
	cut.sliced.connect(cutSliced)
	sliceable.get_material().set_shader_parameter("percent",cut_site)
	var min_dim = margin.size[margin.size.min_axis_index()]
	match game_data['cut_type']:
		0: cut.initialize(margin.size.x/2,margin.size.y*cut_site,min_dim,0);sliceable.get_material().set_shader_parameter("horizontal",true)
		90: cut.initialize(margin.size.x*cut_site,margin.size.y/2,min_dim,90);sliceable.get_material().set_shader_parameter("horizontal",false)

func cutSliced(data):
	cut = null
	sliceAnim.play("sliced")
	
func gameWon(_id):
	emit_signal("game_win")
	print("WON THE GAME")

func _on_slice_area_gui_input(event):
	if event.is_action_pressed("screen_touch"):
		print("DRAGGING")
		#$ColorRect.color = "ff75ff3b"
		if cut != null:
			print(cut)
			cut.inDrag = true
		
	if event.is_action_released("screen_touch"):
		print("ENDING")
		#$ColorRect.color = "43c4fb3b"
		if cut != null:
			cut.inDrag = false
	pass # Replace with function body.


func _on_slice_area_mouse_entered():
	if Input.is_action_pressed("screen_touch"):
		#$ColorRect.color = "ff75ff3b"
		if cut:
			cut.inDrag = true
	pass # Replace with function body.


func _on_slice_area_mouse_exited():
	if cut:
		cut.inDrag = false
	#$ColorRect.color = "43c4fb3b"
	#$ColorRect.color = "43c4fb3b"
	pass # Replace with function body.

func setMargins(val):
	margin.add_theme_constant_override("margin_top", val) #set margins of collect space
	margin.add_theme_constant_override("margin_left", val)
	margin.add_theme_constant_override("margin_bottom", val)
	margin.add_theme_constant_override("margin_right", val)
