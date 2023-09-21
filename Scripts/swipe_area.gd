extends Control
@onready var min_swipe_dist := 300
@onready var initial_pos : Vector2
@onready var ending_pos : Vector2
@onready var in_swipe := false
signal swiped(type, length)

func _on_gui_input(_event):
	if Input.is_action_just_pressed("screen_touch"):
		if not in_swipe:
			in_swipe = true
			initial_pos = get_local_mouse_position()
			
	elif Input.is_action_just_released("screen_touch"):
		if in_swipe:
			ending_pos = get_local_mouse_position()
			var pos_diff = ending_pos-initial_pos
			var swipe_type = abs(pos_diff).max_axis_index()
			var swipe_length = pos_diff.length()
			if abs(swipe_length) > min_swipe_dist:
				if pos_diff[swipe_type] < 0:
					emit_signal("swiped", swipe_type, -swipe_length)
				else:
					emit_signal("swiped", swipe_type, swipe_length)
		in_swipe = false
		
func setSwipeDist(dist):
	min_swipe_dist = dist

func _on_mouse_entered():
	if Input.is_action_pressed("screen_touch"):
		if not in_swipe:
			in_swipe = true
			initial_pos = get_local_mouse_position()

func _on_mouse_exited():
	in_swipe = false
