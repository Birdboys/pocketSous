extends Node2D
@onready var touchZoneA := $touchBegin
@onready var touchZoneB := $touchEnd
@onready var touchLineShape := $touchLine/touchLineShape
@onready var touchLineZoneA := $touchLine/touchBeginArea
@onready var touchLineZoneB := $touchLine/touchEndArea
@onready var sliceLineRect := $sliceLineRect
@onready var zoneAEntered := false
@onready var zoneBEntered := false
@onready var inDrag := false
@onready var drag_width := 128
@onready var cut_id = 0
@export var shine_point := 0.0
signal sliced(i)

func _process(delta):
	sliceLineRect.get_material().set_shader_parameter("start                           ",shine_point)
	
func initialize(x, y, length, rot, id=0):
	position = Vector2(x,y)
	var end_points = [Vector2(-length/4,0),Vector2(length/4,0)]
	touchLineShape.shape.size=Vector2(length/2,drag_width)
		
	sliceLineRect.custom_minimum_size.x = length
	touchZoneA.position = end_points[0]
	touchZoneB.position = end_points[1]
	touchLineZoneA.position = end_points[0]
	touchLineZoneB.position = end_points[1]
	touchLineZoneA.shape.height = length/4
	touchLineZoneB.shape.height = length/4
	cut_id = id
	rotate(deg_to_rad(rot))
	$AnimationPlayer.play("shine")
func _on_touch_begin_mouse_entered():
	zoneAEntered = true
	if inDrag and zoneBEntered:
		emit_signal("sliced", cut_id)
		queue_free()
	pass # Replace with function body.

func _on_touch_end_mouse_entered():
	zoneBEntered = true
	if inDrag and zoneAEntered:
		emit_signal("sliced", cut_id)
		queue_free()

func resetZones():
	zoneAEntered = false
	zoneBEntered = false

func _on_touch_line_mouse_exited():
	inDrag = false
	resetZones()
	pass # Replace with function body.

func _on_touch_line_mouse_entered():
	#inDrag = true
	pass # Replace with function body.
