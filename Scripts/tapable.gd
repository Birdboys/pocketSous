extends TextureButton
var food_id
var original_screen_width = Vector2(720,1280)
signal tapped(id)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_pressed():
	disabled = true
	modulate.a = 0
	emit_signal("tapped", food_id)

func initialize(s, food, food_type, id):
	texture_normal = load("res://Assets/foods/%s/%s.svg" % [food, food_type])
	texture_hover = load("res://Assets/foods/%s/%s.svg" % [food, food_type])
	var texture_size = texture_normal.get_size()
	var max_texture_dim = texture_size[texture_size.max_axis_index()]
	size = texture_size * (s/max_texture_dim)
	pivot_offset = size/2
	#texture_disabled = load("res://Assets/foods/%s/%s_disabled.svg" % [food, food])
	food_id = id
	if id != -1:
		$tapableAnimator.play("wiggle")
	print(size)
	
