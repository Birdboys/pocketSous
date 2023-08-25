extends Control
@onready var cupMargin := $cupMargin
@onready var measuringCup := $cupMargin/cupContainer/measuringCup
@onready var measuringLiquid := $cupMargin/cupContainer/measuringLiquid
@onready var offset = 128 #offset for tapper margin
@onready var is_filling := false
@onready var fill_amount := 0.0
@onready var fill_rate := 1.0
signal game_win
signal game_loss

func _ready():
	setMargins(offset) #set margins of cup space

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_filling:
		fill_amount += fill_rate * delta * 60
		measuringLiquid.get_material().set_shader_parameter("percent", int(fill_amount))
	if fill_amount >= 100:
		fill_amount = 100
		gameWon()
	print(fill_rate)
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
	if event.is_action_released("screen_touch"):
		is_filling = false

func _on_cup_container_mouse_entered():
	if Input.is_action_pressed("screen_touch"):
		is_filling = true

func _on_cup_container_mouse_exited():
	is_filling = false
