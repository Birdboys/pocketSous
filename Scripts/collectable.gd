extends TextureButton
@export var rotation_offset := 0 #rotation offset used for wiggle animation
@onready var original_rotation #original rotation used for wiggle animation
@onready var anim = $collectableAnimator #animator for animations
signal collected(pos)

func _process(_delta):
	rotation = deg_to_rad(original_rotation + rotation_offset) #calculate rotation
	
func initialize(x, y, s, rot, food, food_type):
	texture_normal = load("res://Assets/foods/%s/%s.svg" % [food, food_type]) #load textures based on food
	texture_hover = load("res://Assets/foods/%s/%s.svg" % [food, food_type])
	var texture_size = texture_normal.get_size() #get size of texture
	var max_texture_dim = texture_size[texture_size.max_axis_index()] #get length of max texture dimension
	size = texture_size * (s/max_texture_dim) #use max texutre dim length and min width provided by parent container to scale collectable
	pivot_offset = size/2 #set pivot offset to center 
	original_rotation = rot #set original rotation 
	anim.play("wiggle") #wiggle wiggle wiggle
	position = Vector2(x,y) - size/2 #set position
	
func _on_pressed(): #when pressed
	emit_signal("collected", position + size/2) #emit collected signal
	queue_free() #delete
	pass # Replace with function body.
