extends Control
signal unpause

func _on_gui_input(_event):
	if Input.is_action_just_pressed("screen_touch"):
		print("YIPPEEE")
		get_tree().paused = false
		queue_free()
	pass # Replace with function body.
