extends EmptyState

var intro_to_main_node: VideoPlayer

func _init().():
	physics_process_enabled = false
	input_enabled = false
	process_enabled = false

func _on_enter_state() -> void:
	intro_to_main_node = preload("res://Scenes/MainMenu/Intro2Main.tscn").instance()
	target.add_child(intro_to_main_node)
	intro_to_main_node.connect("finished", self, "_on_intro_fineshed", [], CONNECT_ONESHOT)

func _on_leave_state() -> void:
	intro_to_main_node.queue_free()
	
func _on_intro_fineshed() -> void:
	state_machine.transition("mian_menu")
