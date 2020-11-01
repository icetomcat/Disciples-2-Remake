extends Node2D

class_name MainMenu

signal single_player_pressed
signal intro_pressed

onready var intro_to_main_video: VideoPlayer = $IntroToMain

onready var river_animation: AnimatedSprite = $RiverAnimation
onready var fireflies_animation: AnimatedSprite = $FirefliesAnimation

onready var single_player_label: Label = $Controls/SinglePlayerLabel
onready var intro_label: Label = $Controls/IntroLabel
onready var quit_label: Label = $Controls/QuitLabel

func _ready():
	intro_to_main_video.visible = true
	intro_to_main_video.play()
	intro_to_main_video.connect("finished", self, "_on_intro_fineshed", [], CONNECT_ONESHOT)
	
	single_player_label.connect("gui_input", self, "_on_single_player_label_pressed")
	intro_label.connect("gui_input", self, "_on_introlabel_pressed")
	quit_label.connect("gui_input", self, "_on_quit_label_pressed")

func _input(event):
	if (event is InputEventMouseButton and event.is_pressed()) or event is InputEventKey:
		intro_to_main_video.stop()
		_on_intro_fineshed()

func _on_intro_fineshed():
	intro_to_main_video.visible = false
	river_animation.play()
	fireflies_animation.play()

func _on_single_player_label_pressed(event: InputEvent):
	if event.is_pressed():
		emit_signal("single_player_pressed")

func _on_introlabel_pressed(event: InputEvent):
	if event.is_pressed():
		emit_signal("intro_pressed")
		
func _on_quit_label_pressed(event: InputEvent):
	if event.is_pressed():
		get_tree().quit()

#func _process(delta):
#	pass
