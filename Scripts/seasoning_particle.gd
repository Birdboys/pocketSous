extends CPUParticles2D
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("self_destruct")

func setGradient(grad : Gradient):
	color_initial_ramp = grad
