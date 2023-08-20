extends Node2D
@onready var line := $sliceLine
@onready var touchZoneA := $touchBegin
@onready var touchZoneB := $touchEnd
@onready var touchLineShape := $touchLine/touchLineShape
@onready var touchLineZoneA := $touchLine/touchBeginArea
@onready var touchLineZoneB := $touchLine/touchEndArea
@onready var zoneAEntered := false
@onready var zoneBEntered := false
@onready var inDrag := false
@onready var drag_width := 128
@onready var cut_id = 0
signal sliced(i)
func _process(delta):
	#print(inDrag)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func initialize(x, y, length, rot, id=0):
	position = Vector2(x,y)
	var end_points = [Vector2(-length,0),Vector2(length,0)]
	touchLineShape.shape.size=Vector2(length*2,drag_width)
	rotate(deg_to_rad(rot))
		
	line.points = end_points
	touchZoneA.position = end_points[0]
	touchZoneB.position = end_points[1]
	touchLineZoneA.position = end_points[0]
	touchLineZoneB.position = end_points[1]
	cut_id = id
func _on_touch_begin_mouse_entered():
	print("ENTERED ZONE A")
	zoneAEntered = true
	if inDrag and zoneBEntered:
		emit_signal("sliced", cut_id)
		queue_free()
	pass # Replace with function body.


func _on_touch_end_mouse_entered():
	print("ENTERED ZONE B")
	zoneBEntered = true
	if inDrag and zoneAEntered:
		emit_signal("sliced", cut_id)
		queue_free()

func resetZones():
	zoneAEntered = false
	zoneBEntered = false

func _on_touch_line_mouse_exited():
	print("DRAG ENDED")
	inDrag = false
	resetZones()
	pass # Replace with function body.

func _on_touch_line_mouse_entered():
	#print("DRAG BEGIN")
	#inDrag = true
	pass # Replace with function body.
