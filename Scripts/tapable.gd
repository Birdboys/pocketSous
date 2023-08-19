extends TextureButton
var food_id
var original_screen_width = Vector2(720,1280)
signal tapped(id)
# Called when the node enters the scene tree for the first time.
func _ready():
	pivot_offset = size/2
	pass # Replace with function body.

func _on_pressed():
	disabled = true
	modulate.a = 0
	emit_signal("tapped", food_id)

func initialize(food, food_type, id):
	texture_normal = load("res://Assets/foods/%s/%s.svg" % [food, food_type])
	texture_hover = load("res://Assets/foods/%s/%s.svg" % [food, food_type])
	#texture_disabled = load("res://Assets/foods/%s/%s_disabled.svg" % [food, food])
	food_id = id
	if id != -1:
		$tapableAnimator.play("wiggle")
	
	
