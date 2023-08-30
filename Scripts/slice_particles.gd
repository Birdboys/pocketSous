extends CPUParticles2D
@onready var partAnim := $partAnim

# Called when the node enters the scene tree for the first time.
func _ready():
	partAnim.play("self_destruct")
