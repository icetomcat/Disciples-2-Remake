extends EmptyState

const Tutorial = preload("res://Maps/Tutorial.gd")

var tutorial: Tutorial

func _init().():
	physics_process_enabled = false
	input_enabled = false
	process_enabled = false

func _on_enter_state() -> void:
	tutorial = preload("res://Maps/Tutorial.tscn").instance()
	target.add_child(tutorial)
	tutorial.connect("quit", self, "_on_quit", [], CONNECT_ONESHOT)

func _on_leave_state() -> void:
	tutorial.queue_free()
	
func _on_quit() -> void:
	state_machine.transition("main_menu")
