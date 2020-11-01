extends Node2D

onready var smf = preload("res://addons/fsm/StateMachineFactory.gd").new()

onready var state_machine: StateMachine = smf.create({
  "target": $".",
  "current_state": "none",
  "states": [
	{"id": "none", "state": preload("res://Scripts/Fsm/EmptyState.gd")},
	{"id": "intro", "state": preload("res://Scripts/Fsm/IntroState.gd")},
	{"id": "intro_to_main", "state": preload("res://Scripts/Fsm/IntroToMainState.gd")},
	{"id": "mian_menu", "state": preload("res://Scripts/Fsm/MainMenuState.gd")}
  ],
  "transitions": [
	{"state_id": "none", "to_states": ["intro"]},
	{"state_id": "intro", "to_states": ["intro_to_main"]},
	{"state_id": "intro_to_main", "to_states": ["mian_menu"]},
	{"state_id": "mian_menu", "to_states": ["intro", "single_player"]}
  ]
})

func _ready():
	state_machine.transition('intro')
