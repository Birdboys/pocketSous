extends Control
@onready var pan := $panMargin/pan
@onready var panMargin := $panMargin
@onready var food := $food
@onready var anim := $burnAnim
@onready var offsetTimer := $offsetTimer
@onready var offset := 32 #length of pan margin\
@onready var food_state = 0
@onready var food_type
@onready var food_resized 
@onready var start_offset := randf_range(1.0,4.0)
signal game_win
signal game_loss

func _ready():
	setMargins(offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize(game_data):
	food.texture = await load("res://Assets/foods/%s/%s.svg" % [game_data['food'][0], game_data['food'][1]]) #load food texture
	var texture_size = food.texture.get_size()
	var max_dim = texture_size[texture_size.max_axis_index()]
	var scale_factor = size[size.min_axis_index()]
	food_resized = texture_size * ((scale_factor/2)/max_dim)
	food.size = food_resized
	food.pivot_offset = food.size/2
	food.position = pan.position + pan.size/2 - Vector2(food.size.x/2,food.size.y/2)
	food_type = [game_data['food'][0],"_".join(game_data['food'][1].split("_").slice(0,-1))]
	
func startCooking():
	offsetTimer.start(start_offset)
	
func setMargins(val):
	panMargin.add_theme_constant_override("margin_top", val) #set margins of collect space
	panMargin.add_theme_constant_override("margin_left", val)
	panMargin.add_theme_constant_override("margin_bottom", val)
	panMargin.add_theme_constant_override("margin_right", val)

func gameWon():
	emit_signal("game_win")
	print("WON THE GAME")

func setCooked():
	food_state = 1
	print(food_type[0],food_type[1]+"_cooked")
	food.texture = await load("res://Assets/foods/%s/%s.svg" % [food_type[0],food_type[1]+"_cooked"]) #load food texture
func setBurned():
	food_state = 2
	food.texture = await load("res://Assets/foods/%s/%s.svg" % [food_type[0],food_type[1]+"_burned"]) #load food texture

func endGame():
	match food_state:
		0,2: emit_signal("game_loss")
		1: emit_signal("game_win")
func _on_food_gui_input(event):
	if Input.is_action_just_pressed("screen_touch"):
		endGame()
		
func _on_offset_timer_timeout():
	anim.play("cook")
