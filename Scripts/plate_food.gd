extends CharacterBody2D
@onready var sprite := $plateFoodSprite

const INPUT_SENS = 0.5
@onready var initial_orientation := Vector3.ZERO
@onready var sensitivity = 0.5
@onready var acceleration = 20
@onready var friction = 0.1
@onready var max_speed = 100
func _process(delta):
	if initial_orientation == Vector3.ZERO and Input.get_accelerometer().length() >= 9.5:
		initial_orientation = Input.get_accelerometer()
	if initial_orientation.length() > 0:
		var current_orientation = Input.get_accelerometer()
		var rotation_difference = current_orientation-initial_orientation
		var acc_input = Vector2(rotation_difference.x, -rotation_difference.y)
		if acc_input.length() > sensitivity :
			velocity = velocity + acc_input.normalized() * acceleration #.move_toward(acc_input.normalized() * SPEED, slippy_factor)
		if velocity.length() >= max_speed:
			velocity.normalized() * max_speed
	velocity = lerp(velocity, Vector2.ZERO, friction)
	move_and_slide()

	#if initial_or
func initialize(pos,food):
	position = pos
	sprite.texture =  load("res://Assets/foods/%s/%s.svg" % [food[0], food[1]])
