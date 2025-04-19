class_name Player extends Node3D

@export_category(&"MachineState Information")
@export var hsm : LimboHSM
@export var idle_state : LimboState
@export var moving_state : LimboState
@export var turning_state : LimboState
@export var aim_state : LimboState

@export_category(&"Body References")
@export var anim_player : AnimationPlayer
@export var gun_ray : RayCast3D

var dir : Vector3
var turn_dir : float
var target_dir : Vector3

func _ready() -> void:
	_init_state_machine()
	
	anim_player = bot.find_child(&"AnimationPlayer")
	anim_player.speed_scale = 2
	add_to_group(&"player")
	

func _init_state_machine() -> void:	
	# Idle State Transitions
	hsm.add_transition(idle_state, moving_state, &"moving")
	hsm.add_transition(idle_state, turning_state, &"turning")
	hsm.add_transition(idle_state, aim_state, &"aiming")
	
	# Moving State Transitions
	hsm.add_transition(moving_state, idle_state, moving_state.EVENT_FINISHED)
	
	# Turning State Transitions
	hsm.add_transition(turning_state, idle_state, turning_state.EVENT_FINISHED)
	
	# Aiming State Transitions
	hsm.add_transition(aim_state, idle_state, aim_state.EVENT_FINISHED)
	
	hsm.initialize(self)
	hsm.set_active(true)
