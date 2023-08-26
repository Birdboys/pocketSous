extends Control
@onready var cupMargin := $cupMargin
@onready var measuringCup := $cupMargin/cupContainer/measuringCup
@onready var measuringLiquid := $cupMargin/cupContainer/measuringLiquid
@onready var liquidParticles := $liquidParticles
@onready var fillTimer := $fillTimer
@onready var offset = 128 #offset for tapper margin
@onready var is_filling := false
@onready var fill_amount := 0.0
@onready var fill_rate := 0.5
@onready var fill_range := 5.0
@onready var fill_time := 0.5
@onready var desired_fill : int
signal game_win
signal game_loss
signal over_flow

func _ready():
	setMargins(offset) #set margins of cup space
	liquidParticles.position = cupMargin.position + Vector2(cupMargin.size.x/2,0)
	await get_tree().process_frame

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_filling and fill_amount < 100:
		fill_amount += fill_rate * delta * 60
		measuringLiquid.get_material().set_shader_parameter("percent", int(fill_amount))
		
	if abs(fill_amount - desired_fill) < fill_range:
		if fillTimer.is_stopped():
			fillTimer.start(fill_time)
	else:
		fillTimer.stop()

func initialize(game_data):
	measuringLiquid.get_material().set_shader_parameter("percent", int(0))
	measuringLiquid.get_material().set_shader_parameter("color",game_data['color'])
	desired_fill = game_data['fill_val'] * 25
	measuringCup.texture = load("res://Assets/foods/utensil/measuring_cup_%s.svg" % game_data['fill_val'])

func gameWon():
	emit_signal("game_win")
	print("WON THE GAME")

func setMargins(val):
	cupMargin.add_theme_constant_override("margin_top", val) #set margins of cup space
	cupMargin.add_theme_constant_override("margin_left", val)
	cupMargin.add_theme_constant_override("margin_bottom", val)
	cupMargin.add_theme_constant_override("margin_right", val)

func _on_cup_container_gui_input(event: InputEvent):
	if event.is_action_pressed("screen_touch"):
		is_filling = true
		#liquidParticles.emitting = true
	if event.is_action_released("screen_touch"):
		is_filling = false
		#liquidParticles.emitting = false

func _on_cup_container_mouse_entered():
	if Input.is_action_pressed("screen_touch"):
		is_filling = true
		#liquidParticles.emitting = true

func _on_cup_container_mouse_exited():
	is_filling = false
	#liquidParticles.emitting = false

func _on_fill_timer_timeout():
	gameWon()
	pass # Replace with function body.
