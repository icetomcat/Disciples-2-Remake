extends EmptyState

var intro_node: Intro

func _init().():
	physics_process_enabled = false
	input_enabled = false
	process_enabled = false

func _on_enter_state() -> void:
	intro_node = preload("res://Scenes/Intro.tscn").instance()
	target.add_child(intro_node)
	intro_node.connect("finished", self, "_on_intro_fineshed", [], CONNECT_ONESHOT)

func _on_leave_state() -> void:
	intro_node.queue_free()
	
func _on_intro_fineshed() -> void:
	state_machine.transition("main_menu")
