extends Control
@onready var tapper := $margins/tapper
@onready var tapBar := $tapBar
@onready var total_taps : int
@onready var current_taps := 0
signal game_win
signal game_loss

func _ready():
	print(rad_to_deg(Vector2(390.6, 199.2517).angle_to(Vector2(393.0111, 196.8389))))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func initialize(food, num_tap):
	tapper.texture =  load("res://Assets/foods/%s/%s.svg" % [food[0], food[1]])
	tapper.pivot_offset = tapper.size/2
	tapper.rotation = deg_to_rad(randi_range(-30,30))
	total_taps = num_tap
	tapBar.max_value = num_tap
	tapBar.value = 0
	tapBar.custom_minimum_size = Vector2(size.x/20,0)
func gameWon():
	emit_signal("game_win")
	print("WON THE GAME")


func _on_tapper_gui_input(event: InputEvent):
	if event.is_action_pressed("screen_touch"):
		current_taps += 1
		tapBar.value += 1
		if current_taps >= total_taps:
			gameWon()
	
