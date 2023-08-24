extends Control
@onready var plate_food := preload("res://Scenes/plate_food.tscn") #instantiatable plate food scene
@onready var current_food = null #pointer to plate food
@onready var centerArea := $centerArea 
@onready var centerAreaShape := $centerArea/centerAreaShape
@onready var centerTimer := $centerTimer
@onready var plateMargin := $plateMargin
@onready var plate := $plateMargin/plate
@onready var center_time = 0.25 #time food needs to be touching center of plate 
@onready var offset = 128 #length of collect margin
@onready var plate_area_ratio = 10 #ratio for center area within plate
@onready var plate_food_ratio = 2 #ratio for food relative to plate
signal game_win
signal game_loss

# Called when the node enters the scene tree for the first time.
func _ready():
	setMargins(offset) #set margins
	
func initialize(game_data):
	centerArea.position = plate.position + plate.size/2 #center the plate center area
	centerAreaShape.shape.radius = plate.size[plate.size.min_axis_index()]/(2*plate_area_ratio) #set center area radius from ratios
	current_food = plate_food.instantiate() #instantiate food
	add_child(current_food) #add child 
	var pos_dir = Vector2.RIGHT.rotated(deg_to_rad(randi_range(0,360))) #select random direction to place food in
	var pos_dist = plate.size[plate.size.min_axis_index()]/2 #get distance to put food away from plate 
	var pos = size/2 + pos_dir*pos_dist #get food position from direction and distance
	current_food.initialize(pos,game_data['food'],plate.size[plate.size.min_axis_index()]/plate_food_ratio) #initialize food
	
func _on_center_area_area_entered(area):
	centerTimer.start(center_time) #when food enters center area start timer

func _on_center_area_area_exited(area):
	centerTimer.stop() #when food exits center area stop timer

func _on_center_timer_timeout():
	emit_signal("game_win") #when timer goes off food has been in center long enough - game won

func setMargins(val):
	plateMargin.add_theme_constant_override("margin_top", val) #set margins of collect space
	plateMargin.add_theme_constant_override("margin_left", val)
	plateMargin.add_theme_constant_override("margin_bottom", val)
	plateMargin.add_theme_constant_override("margin_right", val)
