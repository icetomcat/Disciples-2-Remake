extends VideoPlayer

func _input(event):
	if (event is InputEventMouseButton and event.is_pressed()) or event is InputEventKey:
		stop()
		emit_signal("finished")
