extends Control
@onready var plate_food := preload("res://Scenes/plate_food.tscn")
@onready var current_food = null
@onready var centerArea = $centerArea
@onready var centerTimer = $centerTimer
@onready var center_time = 0.75
signal game_win
signal game_loss

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize(food):
	print($plate.size)
	centerArea.position = $plate.position + $plate.size/2
	#centerArea.position = Vector2(size.x/2,size.x/2)
	current_food = plate_food.instantiate()
	add_child(current_food)
	#var pos = Vector2(randi_range(0,size.x), randi_range(0,size.y))
	var pos_dir = Vector2.RIGHT.rotated(deg_to_rad(randi_range(0,360)))
	var pos_dist = size.x/2
	var pos = size/2 + pos_dir*pos_dist
	current_food.initialize(pos,food)
	
func _on_center_area_area_entered(area):
	centerTimer.start(center_time)
	pass # Replace with function body.

func _on_center_area_area_exited(area):
	centerTimer.stop()
	pass # Replace with function body.

func _on_center_timer_timeout():
	emit_signal("game_win")
	pass # Replace with function body.
