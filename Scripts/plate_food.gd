extends CharacterBody2D
@onready var sprite := $plateFoodSprite

const SPEED = 300
const INPUT_SENS = 0.5
func _physics_process(delta):
	#var acc_input = Vector2(Input.get_accelerometer().x, -Input.get_accelerometer().y)
	#velocity = acc_input.normalized() * SPEED
	move_and_slide()
	
	var acc_input = Vector2(Input.get_accelerometer().x, -Input.get_accelerometer().y)
	var acc_strength = acc_input.length()
	if acc_strength > 0.5:
		velocity = acc_input.normalized() * SPEED * acc_strength/10.0
	velocity = lerp(velocity, Vector2.ZERO, 0.25)
	move_and_slide()

func initialize(pos,food):
	position = pos
	sprite.texture =  load("res://Assets/foods/%s/%s.svg" % [food[0], food[1]])
