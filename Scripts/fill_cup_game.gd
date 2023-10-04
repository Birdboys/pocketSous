extends Control
@onready var cupMargin := $cupMargin
@onready var measuringCup := $cupMargin/cupContainer/measuringCup
@onready var measuringLiquid := $cupMargin/cupContainer/measuringLiquid
@onready var fillTimer := $fillTimer
@onready var liquidParticles := $cupMargin/liquidParticles
@onready var offset = 128 #offset for tapper margin
@onready var is_filling := false #is the player holding on screen to fill
@onready var fill_amount := 0.0 #current fill amount - used to keep track of fill
@onready var fill_rate := 0.50 #fill rate 
@onready var fill_range := 5.0 #range of fill values that are acceptable for winning - -fill_range,fill_range
@onready var fill_time := 0.5 #time in seconds liquid must be in range for winning
@onready var desired_fill : int #holds desired fill percent - set in initialize
@onready var finished = false
signal game_win 
signal game_loss
signal over_flow

func _ready():
	setMargins(offset) #set margins of cup space

func _process(delta):
	if is_filling: #if we are filling 
		fill_amount += fill_rate * delta * 60 #add to fill amount
		measuringLiquid.get_material().set_shader_parameter("percent", int(fill_amount)) #set shader for fill based on fill amount
		
	if abs(fill_amount - desired_fill) < fill_range: #if we are within winning range
		if fillTimer.is_stopped(): #if we haven't already started timer for winning 
			fillTimer.start(fill_time) #start timer
	else: #if we aren't in winning fill range
		fillTimer.stop() #stop timer
	if fill_amount > desired_fill + fill_range:
		gameLost()

func initialize(game_data):
	print(game_data['color'])
	measuringLiquid.get_material().set_shader_parameter("percent", int(0)) #initialize shader parameters
	measuringLiquid.get_material().set_shader_parameter("color",Color(game_data['color'])) #get liquid color from game data
	desired_fill = game_data['fill_val'] * 25 #set desired fill from game data - fill_val is int from 1-4 so multiply to get 25-100 percent
	measuringCup.texture = load("res://Assets/foods/utensil/measuring_cup_%s.svg" % game_data['fill_val']) #load cup variation based on fill val
	liquidParticles.position = cupMargin.position + Vector2(cupMargin.size.x/2,32)
	liquidParticles.texture = load("res://Assets/foods/particle/%s_particle.svg" % game_data['food'][0])
	liquidParticles.color = game_data['color']
	
func gameWon():
	if not finished:
		finished = true
		liquidParticles.queue_free()
		emit_signal("game_win")
func gameLost():
	if not finished:
		finished = true
		liquidParticles.queue_free()
		emit_signal("game_loss")
func setMargins(val):
	cupMargin.add_theme_constant_override("margin_top", val) #set margins of cup space
	cupMargin.add_theme_constant_override("margin_left", val)
	cupMargin.add_theme_constant_override("margin_bottom", val)
	cupMargin.add_theme_constant_override("margin_right", val)

func _on_cup_container_gui_input(event: InputEvent):
	if event.is_action_pressed("screen_touch") and not finished: #if screen touched
		is_filling = true #we are filling
		liquidParticles.emitting = true
	if event.is_action_released("screen_touch") and not finished: #if not 
		liquidParticles.emitting = false
		is_filling = false #we are not filling

func _on_cup_container_mouse_entered():
	if Input.is_action_pressed("screen_touch"): #if area entered while screen touched
		is_filling = true #we are filling
		if not finished:
			liquidParticles.emitting = true

func _on_cup_container_mouse_exited(): #if area exited
	is_filling = false #we are not filling
	if not finished:
		liquidParticles.emitting = false
	
func _on_fill_timer_timeout(): #if fill has been in desired range for x time
	gameWon() #we won

