extends Node2D

signal quit

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			emit_signal("quit")
