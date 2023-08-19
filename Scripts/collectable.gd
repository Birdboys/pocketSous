extends TextureButton
@export var rotation_offset := 0
var original_rotation
signal collected
# Called when the node enters the scene tree for the first time.
func _ready():
	pivot_offset = size/2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = original_rotation + rotation_offset

func initialize(x, y, rot, food, food_type):
	original_rotation = rot
	position = Vector2(x, y)
	texture_normal = load("res://Assets/foods/%s/%s.svg" % [food, food_type])
	texture_hover = load("res://Assets/foods/%s/%s.svg" % [food, food_type])
	$collectableAnimator.play("wiggle")
	position = Vector2(x,y) - size/2
	#texture_disabled = load("res://Assets/foods/%s/%s_disabled.svg" % [food, food])
	
func _on_pressed():
	emit_signal("collected")
	queue_free()
	pass # Replace with function body.
