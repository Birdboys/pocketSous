extends Control
@onready var collectable = preload("res://Scenes/collectable.tscn")
@onready var collectSpace := $collectMargin/collectSpace
var rotation_range = 30
var current_collect = 0
var total_collect = 0
var offset = 128
signal game_win
signal game_loss
signal collected(num_left)
func _ready():
	print("READY")
func _process(delta):
	pass
	#print(size, get_rect().size, get_parent_area_size())
func initialize(num_collects, good_collects):
	print(size)
	total_collect = num_collects
	var play_area = collectSpace.size
	for x in range(num_collects):
		var new_collect = collectable.instantiate()
		collectSpace.add_child(new_collect)
		new_collect.collected.connect(onCollected)
		var collect_choice = good_collects[randi() % good_collects.size()]
		var new_x = randi_range(0, play_area.x)
		var new_y = randi_range(0, play_area.y)
		var min_dim = play_area[play_area.max_axis_index()]
		new_collect.initialize(new_x,new_y,min_dim/3,randi_range(-rotation_range,rotation_range),collect_choice[0],collect_choice[1])

func onCollected():
	current_collect += 1
	if current_collect == total_collect:
		current_collect = 0
		emit_signal("game_win")
		pass
	else:
		emit_signal("collected", total_collect-current_collect)

