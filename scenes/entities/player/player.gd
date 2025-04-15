class_name Player extends Node3D

@export var hsm : LimboHSM
@export var idle_state : LimboState
@export var moving_state : LimboState

var dir : Vector3

func _ready() -> void:
	_init_state_machine()

func _init_state_machine() -> void:
	hsm.add_transition(idle_state, moving_state, &"moving")
	hsm.add_transition(moving_state, idle_state, moving_state.EVENT_FINISHED)
	
	hsm.initialize(self)
	hsm.set_active(true)
