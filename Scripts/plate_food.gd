extends CharacterBody2D
@onready var sprite := $plateFoodSprite
@onready var plateFoodAreaShape := $plateFoodArea/plateFoodAreaShape
@onready var initial_orientation := Vector3.ZERO #initial orientation of phone - set in process
@onready var sensitivity = 1.5 #sensitivity of accelerometer tilt
@onready var acceleration = 100 #acceleration of food
@onready var friction = 0.1 #friction force of food
@onready var max_speed = 350 #max speed of food

func _process(_delta):
	if initial_orientation == Vector3.ZERO and Input.get_accelerometer().length() >= 9.5: #if we have full accelerometer data from device
		initial_orientation = Input.get_accelerometer() #set initial orientation
	if initial_orientation.length() > 0: #if we have initial orientation
		var current_orientation = Input.get_accelerometer() #get current orientation
		var rotation_difference = current_orientation-initial_orientation #get difference between current and initial
		var acc_input = Vector2(rotation_difference.x, -rotation_difference.y) #use difference to get x and y forces
		if acc_input.length() > sensitivity : #if force is greater than sensitivity
			velocity = velocity + acc_input.normalized() * acceleration * (acc_input.length()/10) #add acceleration to velocity - value scaled based on accelerometer force relative to gravity
		if velocity.length() >= max_speed: #if going to fast
			velocity = velocity.normalized() * max_speed #set speed to max speed
	velocity = lerp(velocity, Vector2.ZERO, friction) #induce friction
	move_and_slide() #move it move it

func initialize(pos,food,scale_factor):
	position = pos #set position
	sprite.texture = load("res://Assets/foods/%s/%s.svg" % [food[0], food[1]]) #load texture
	var max_sprite_dim = sprite.texture.get_size()[sprite.texture.get_size().max_axis_index()] #get max sprite dimension length for scaling
	sprite.scale = Vector2(scale_factor/max_sprite_dim, scale_factor/max_sprite_dim) #scale sprite based on max sprite dimension
	plateFoodAreaShape.shape.radius = 32 #set shape area
	
