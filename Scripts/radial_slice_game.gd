extends Control
@onready var sliceable := $sliceMargin/sliceable
@onready var slice := preload("res://Scenes/slice.tscn")
@onready var margin := $sliceMargin
@onready var cuts = []
signal game_win
signal game_loss

func _process(delta):
	pass
	#print(cuts)
func initialize(food_type, num_cut):
	sliceable.texture = load("res://Assets/foods/%s/%s.svg" %[food_type[0],food_type[1]])
	await get_tree().process_frame
	
	var start_angle = 0
	var angle_offset = 180/num_cut
	for x in range(num_cut):
		var new_cut = slice.instantiate()
		margin.add_child(new_cut)
		cuts.append(new_cut)
		new_cut.sliced.connect(sliceSliced)
		new_cut.initialize(margin.size.x/2,margin.size.y/2,margin.size.x/2, start_angle, x)
		start_angle += angle_offset
	#match cut_type:
		#'horizontal': cut.initialize(margin.size.x/2,margin.size.y*cut_site,margin.size.x/2, 'horizontal')
		#'vertical': cut.initialize(margin.size.x*cut_site,margin.size.y/2,margin.size.x/2, 'vertical')
func sliceSliced(s):
	cuts[s] = null
	if cuts.all(func(c): return c == null):
		gameWon()
	pass
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
	pass # Replace with function body.


func _on_slice_area_mouse_entered():
	if Input.is_action_pressed("screen_touch"):
		#$ColorRect.color = "ff75ff3b"
		for cut in cuts:
			if cut:
				cut.inDrag = true
	pass # Replace with function body.


func _on_slice_area_mouse_exited():
	for cut in cuts:
		if cut:
			cut.inDrag = false
