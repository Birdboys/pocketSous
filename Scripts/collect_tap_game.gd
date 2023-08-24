extends Control
@onready var collectable = preload("res://Scenes/collectable.tscn") #instantiatable collectable scene
@onready var collectSpace := $collectMargin/collectSpace #area where collectables are added
@onready var collectMargin := $collectMargin #margin for collect space - keeps food from spawning off screen (ideally)
@onready var offset = 128 #length of collect margin
@onready var collectable_scale = 1.0/4.0 #scale of collectable relative to collect area
var rotation_range := 30 #max value for range of degrees collectable can be rotated when spawned in for variety (-range,range)
var current_collect := 0 #current collectables collected - used to determine when game is finished
var total_collect : int #total number of collectables spawned - set in initialize from game data

signal game_win
signal game_loss
signal collected(num_left)

func _ready():
	setMargins(offset)
	
func initialize(game_data): #initialize collect game from data
	print("COLLECT GAME SIZE: %s" % size)
	total_collect = game_data['num_collect'] #get total collectables to spawn
	var play_area = collectSpace.size #get play area of collectSpace within margin
	print("COLLECT GAME AREA SIZE: %s" % play_area)
	for x in range(total_collect): #loop for creating collectables
		var new_collect = collectable.instantiate() #instantiate collectable from scene
		collectSpace.add_child(new_collect) #add it to collect space
		new_collect.collected.connect(onCollected) #connect collected signal to onCollected - used to keep track of collectables left
		var new_x = randi_range(0, play_area.x) #get x value within play area
		var new_y = randi_range(0, play_area.y) #get y value within play area
		var min_dim = play_area[play_area.min_axis_index()] #get length of minimum play area dimension - used to set collectable size relative to play area
		new_collect.initialize(new_x,new_y,min_dim*collectable_scale,randi_range(-rotation_range,rotation_range),game_data['food'][0],game_data['food'][1]) #initialize collectable

func onCollected(): #connected to collected signal in collectables
	current_collect += 1 #increment number of collectables collected
	if current_collect >= total_collect: #if we have collected them all
		emit_signal("game_win") #emit win signal
	else:
		emit_signal("collected", total_collect-current_collect) #emit collected signal

func setMargins(val):
	collectMargin.add_theme_constant_override("margin_top", val) #set margins of collect space
	collectMargin.add_theme_constant_override("margin_left", val)
	collectMargin.add_theme_constant_override("margin_bottom", val)
	collectMargin.add_theme_constant_override("margin_right", val)
