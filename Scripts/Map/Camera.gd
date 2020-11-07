extends Camera2D

export var move_speed = 500

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		global_position += Vector2.LEFT * delta * move_speed
	elif Input.is_action_pressed("ui_right"):
		global_position += Vector2.RIGHT * delta * move_speed
	if Input.is_action_pressed("ui_up"):
		global_position += Vector2.UP * delta * move_speed
	elif Input.is_action_pressed("ui_down"):
		global_position += Vector2.DOWN * delta * move_speed
