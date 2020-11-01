extends Node2D

class_name MainMenu

signal single_player_pressed
signal intro_pressed

onready var single_player_label: Label = $"Controls/SinglePlayerLabel"
onready var intro_label: Label = $"Controls/IntroLabel"
onready var quit_label: Label = $"Controls/QuitLabel"

func _ready():
	single_player_label.connect("gui_input", self, "_on_single_player_label_pressed")
	intro_label.connect("gui_input", self, "_on_introlabel_pressed")
	quit_label.connect("gui_input", self, "_on_quit_label_pressed")

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
