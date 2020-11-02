extends EmptyState

var main_menu_node: MainMenu

func _init().():
	physics_process_enabled = false
	input_enabled = false
	process_enabled = false
	
func _on_enter_state() -> void:
	main_menu_node = preload("res://Scenes/MainMenu/MainMenu.tscn").instance()
	target.add_child(main_menu_node)
	main_menu_node.connect("intro_pressed", self, "_on_intro_pressed", [], CONNECT_ONESHOT)
	main_menu_node.connect("tutorial_pressed", self, "_on_tutorial_pressed", [], CONNECT_ONESHOT)

func _on_leave_state() -> void:
	main_menu_node.queue_free()
	
func _on_intro_pressed() -> void:
	state_machine.transition("intro")
	
func _on_tutorial_pressed() -> void:
	state_machine.transition("tutorial")
