extends Node2D

signal finished

onready var video = $"VideoPlayer"

func _ready():
	video.play()
	video.connect("finished", self, "_on_intro_fineshed")
	pass # Replace with function body.

func _input(event):
	if (event is InputEventMouseButton and event.is_pressed()) or event is InputEventKey:
		_on_intro_fineshed()
		
func _on_intro_fineshed():
	video.stop()
	emit_signal("finished")

#func _process(delta):
#	pass
