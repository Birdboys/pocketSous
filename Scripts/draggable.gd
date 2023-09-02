extends TextureRect
@onready var foodArea := $foodArea
@onready var foodAreaShape := $foodArea/foodAreaShape
@onready var shape_radius = 32
@onready var in_drag = false
@onready var in_zone = false
@onready var food_id
@onready var color
signal placed(id, color)

func initialize(pos,food,scale_factor, id=null):
	texture = load("res://Assets/foods/%s/%s.svg" % [food[0], food[1]]) #load texture
	var texture_size = texture.get_size() #get size of texture
	var max_texture_dim = texture_size[texture_size.max_axis_index()] #get length of max texture dimension
	size = texture_size * (scale_factor/max_texture_dim) #use max texutre dim length and min width provided by parent container to scale collectable
	pivot_offset = size/2 #set pivot offset to center 
	foodAreaShape.shape.radius = size[size.min_axis_index()]/2
	foodArea.position = size/2
	food_id = id
	color = FoodMaster.food[food[1]]['main_color']
	position = pos - size/2
	
func _process(delta):
	if in_drag:
		global_position = get_viewport().get_mouse_position() - size/2

func _on_food_area_area_entered(area):
	if area.get_parent().name == "bowl":
		in_zone = true

func _on_food_area_area_exited(area):
	if area.get_parent().name == "bowl":
		in_zone = false


func _on_gui_input(event):
	if Input.is_action_just_pressed("screen_touch"):
		in_drag = true
	elif Input.is_action_just_released("screen_touch"):
		if in_drag and in_zone:
			emit_signal("placed",food_id, color)
			queue_free()
		in_drag = false

func _on_mouse_exited():
	print("MOUSEEXIT")
	#in_drag = false
