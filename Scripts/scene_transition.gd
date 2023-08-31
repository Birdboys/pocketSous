extends Control
@onready var ogRect := $ogColor
@onready var newRect := $newColor
@onready var split := $split
@onready var color1 := $split/color1
@onready var color2 := $split/color2
@onready var anim := $transitionAnimator
@onready var scoreLabel := $newColor/score
@onready var shadowShader := $newColor/shadowShader
@onready var type
@onready var distance
@onready var score_val
@onready var split_offset_initial
@export var splitPercent := 0.0
@export var is_goin := false
signal transition_done

func _ready():
	#initialize("left-right","blue","orange")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_goin:
		split.split_offset = split_offset_initial + distance * splitPercent

func initialize(t, og_theme, new_theme, score=null):
	var og_color = load("res://Assets/themes/%sMinigame.tres" % og_theme).get_stylebox("panel","bg").bg_color
	var new_color = load("res://Assets/themes/%sMinigame.tres" % new_theme).get_stylebox("panel","bg").bg_color
	type = t
	match type:
		"right-left":
			split.vertical = false
			distance = -size.x
			split_offset_initial = -distance/2
			ogRect.color = og_color
			color1.color = og_color
			newRect.color = new_color
			color2.color = new_color
		"bottom-top":
			split.vertical = true
			distance = -size.y
			split_offset_initial = -distance
			ogRect.color = og_color
			color1.color = og_color
			newRect.color = new_color
			color2.color = new_color
		"top-bottom":
			split.vertical = true
			distance = size.y
			split_offset_initial = 0
			ogRect.color = og_color
			color2.color = og_color
			newRect.color = new_color
			color1.color = new_color
		"left-right":
			split.vertical = false
			distance = size.x
			split_offset_initial = -distance/2
			ogRect.color = og_color
			color2.color = og_color
			newRect.color = new_color
			color1.color = new_color
	if score != null:
		scoreLabel.text = str(score)
		shadowShader.get_material().set_shader_parameter("background_color",load("res://Assets/themes/%sMinigame.tres" % new_theme).get_stylebox("panel","bg").bg_color)
		shadowShader.get_material().set_shader_parameter("shadow_color",load("res://Assets/themes/%sMinigame.tres" % new_theme).get_color("default_color","scoreLabel"))
	score_val = score
	is_goin = true
	anim.play("transition")

func transitionDone():
	if score_val != null:
		anim.play("showScore")
	else:
		emit_signal("transition_done")
		queue_free()

func scoreDone():
	emit_signal("transition_done")
	queue_free()
