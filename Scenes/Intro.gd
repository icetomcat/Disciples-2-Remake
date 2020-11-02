extends Node2D

signal finished

onready var video = $"VideoPlayer"

func _ready():
	video.play()
	video.connect("finished", self, "_on_intro_fineshed")
	pass # Replace with function body.

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			_on_intro_fineshed()
	if event is InputEventMouseButton:
		if event.pressed:
			_on_intro_fineshed()
		
func _on_intro_fineshed():
	video.stop()
	emit_signal("finished")

#func _process(delta):
#	pass
