extends Control
signal unpause(id)

func _on_resume_pressed():
	get_tree().paused = false
	emit_signal("unpause",0)
	queue_free()

func _on_main_pressed():
	get_tree().paused = false
	emit_signal("unpause",1)
	queue_free()

func _on_quit_pressed():
	get_tree().paused = false
	emit_signal("unpause",2)
	queue_free()
