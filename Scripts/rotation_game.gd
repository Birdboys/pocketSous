extends Control
@onready var rotator := $margins/rotator
@onready var prev_position = null
@onready var rotation_center 
@onready var sensitivity = 3
signal game_win
signal game_loss

func _ready():
	print(rad_to_deg(Vector2(390.6, 199.2517).angle_to(Vector2(393.0111, 196.8389))))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(abs(int(rad_to_deg(rotator.rotation))))
	var rot_degrees = abs(int(rad_to_deg(rotator.rotation))) % 360
	if rot_degrees < sensitivity:
		gameWon()
	pass
	
func initialize(food):
	print(size)
	rotator.rotation = deg_to_rad(randi_range(10,350))
	rotator.texture =  load("res://Assets/foods/%s/%s.svg" % [food[0], food[1]])
	rotator.pivot_offset = rotator.size/2
	rotation_center = rotator.position+rotator.size/2

func _on_touch_area_gui_input(event: InputEvent):
	
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("screen_touch"):
			if prev_position:
				var initial_vector = (prev_position - rotation_center)
				var current_vector = (event.position - rotation_center)
				var angle = initial_vector.angle_to(current_vector)
				rotator.rotation += angle
		prev_position = event.position
	if Input.is_action_just_released("screen_touch"):
		prev_position = null
			
	pass # Replace with function body.
func _on_touch_area_mouse_exited():
	prev_position = null
	pass # Replace with function body.

func gameWon():
	emit_signal("game_win")
	print("WON THE GAME")
