extends Control
@onready var sliceable := $sliceMargin/sliceable
@onready var slice := preload("res://Scenes/slice.tscn")
@onready var margin := $sliceMargin
@onready var cut
signal game_win
signal game_loss

func initialize(food_type, cut_type):
	sliceable.texture = load("res://Assets/foods/%s/%s.svg" %[food_type[0],food_type[1]])
	var cut_range = margin.size
	await get_tree().process_frame
	
	var cut_site = randf_range(0.25,0.75)
	cut = slice.instantiate()
	margin.add_child(cut)
	cut.sliced.connect(gameWon)
	match cut_type:
		0: cut.initialize(margin.size.x/2,margin.size.y*cut_site,margin.size.x/2, 0)
		90: cut.initialize(margin.size.x*cut_site,margin.size.y/2,margin.size.x/2, 90)

func gameWon(_id):
	cut = null
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
		if cut:
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
