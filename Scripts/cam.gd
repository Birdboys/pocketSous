extends Camera2D
var SHAKE_STRENGTH = 5
@onready var anim := $anim
@onready var shake_noise := FastNoiseLite.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return
	if Input.is_action_pressed("screen_touch"):
		offset.x = randf_range(-SHAKE_STRENGTH,SHAKE_STRENGTH)
		offset.y = randf_range(-SHAKE_STRENGTH,SHAKE_STRENGTH)
	else:
		offset = Vector2.ZERO
func shake(_strength):
	anim.play("shake")
