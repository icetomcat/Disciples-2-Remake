extends Node2D

onready var smf = preload("res://addons/fsm/StateMachineFactory.gd").new()

onready var state_machine: StateMachine = smf.create({
  "target": $".",
  "current_state": "none",
  "states": [
	{"id": "none", "state": preload("res://Scripts/Fsm/EmptyState.gd")},
	{"id": "intro", "state": preload("res://Scripts/Fsm/IntroState.gd")},
	{"id": "main_menu", "state": preload("res://Scripts/Fsm/MainMenuState.gd")}
  ],
  "transitions": [
	{"state_id": "none", "to_states": ["intro"]},
	{"state_id": "intro", "to_states": ["main_menu"]},
	{"state_id": "main_menu", "to_states": ["intro", "single_player"]}
  ]
})

func _ready():
	state_machine.transition('intro')
