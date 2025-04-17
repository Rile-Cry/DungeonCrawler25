class_name Player extends Node3D

@export_category(&"MachineState Information")
@export var hsm : LimboHSM
@export var idle_state : LimboState
@export var moving_state : LimboState
@export var turning_state : LimboState

@export_category(&"Body References")
@export var bot : Node3D

var dir : Vector3
var anim_player : AnimationPlayer
var turn_dir : float
var target_dir : Vector3

func _ready() -> void:
	_init_state_machine()
	
	anim_player = bot.find_child(&"AnimationPlayer")

func _init_state_machine() -> void:	
	# Idle State Transitions
	hsm.add_transition(idle_state, moving_state, &"moving")
	hsm.add_transition(idle_state, turning_state, &"turning")
	
	# Moving State Transitions
	hsm.add_transition(moving_state, idle_state, moving_state.EVENT_FINISHED)
	
	# Turning State Transitions
	hsm.add_transition(turning_state, idle_state, turning_state.EVENT_FINISHED)
	
	hsm.initialize(self)
	hsm.set_active(true)
