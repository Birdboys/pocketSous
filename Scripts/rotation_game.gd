extends Control
@onready var rotator := $margins/rotator
@onready var prev_position = null #used for calculating rotation from dragging
@onready var rotation_center = null  #center position of food
@onready var sensitivity = 0.5 #sensitivity for how close rotation must be to 0 - (-sensitivity,sensitivity)
@onready var game_won = false #used to make sure game_win signal only fires once
signal game_win
signal game_loss

func _process(delta): 
	var rot_degrees = abs(int(rad_to_deg(rotator.rotation))) % 360 #get rotation degrees from food
	if rot_degrees < sensitivity and not game_won and rotation_center: #if rotation is close enough to 0
		gameWon() #we won game

func initialize(game_data):
	rotator.rotation = deg_to_rad(randi_range(60,300)) #get random initial rotation for food 
	rotator.texture =  load("res://Assets/foods/%s/%s.svg" % [game_data['food'][0], game_data['food'][1]]) #load food
	rotator.pivot_offset = rotator.size/2 #set food pivor offset
	rotation_center = rotator.position+rotator.size/2 #get center position of food

func _on_touch_area_gui_input(event: InputEvent):
	if event is InputEventMouseMotion: 
		if Input.is_action_pressed("screen_touch"): #if touch input in area
			if prev_position: #if we have a previousu position
				var initial_vector = (prev_position - rotation_center) #get vector from food center to previous pos
				var current_vector = (event.position - rotation_center) #get vector from food center to current pos
				var angle = initial_vector.angle_to(current_vector) #get angle between vectors
				rotator.rotation += angle #add rotation to food
		prev_position = event.position #prev touch position equals current event position - used for next calc
	if Input.is_action_just_released("screen_touch"): #if we release touch
		prev_position = null #set previous position to null

func _on_touch_area_mouse_exited(): #if touch leaves area
	prev_position = null #previous position is null

func gameWon():
	game_won = true
	emit_signal("game_win")
