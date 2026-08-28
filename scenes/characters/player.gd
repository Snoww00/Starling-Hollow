extends CharacterBody2D

var direction: Vector2
var last_direction: Vector2
var speed = 50
var can_move : bool = true
@onready var move_state_machine = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine = $Animation/AnimationTree.get("parameters/ToolStateMachine/playback")
@onready var tool_ui: Control = $"../../User Interface/ToolUI"
@onready var player = $Objects/Player
var current_tool : Enum.Tool 
var current_seed : Enum.Seed
var DEFAULT_TARGET_POSITION : Vector2 = Vector2(0,1)
var TILE_SIZE = 16;

signal tool_use(tool: Enum.Tool, pos: Vector2)
signal tool_target(tool: Enum.Tool, pos: Vector2)

func get_tool_name(tool:Enum.Tool) -> String:
	match tool:
		Enum.Tool.HOE:
			return "Hoe"
		Enum.Tool.FISH:
			return "Fish"
		Enum.Tool.WATER:
			return "Water"
		Enum.Tool.SWORD:
			return "Sword"
		Enum.Tool.AXE:
			return "Axe"
		Enum.Tool.SEED:
			return "Seed"
		_:return ""

func _physics_process(_delta: float) -> void:
	if can_move:
		get_basic_input()
		move()
		animate()
	if direction:
		last_direction = direction
	tool_target_emit()

func get_basic_input():
	if Input.is_action_just_pressed('tool_forward') or Input.is_action_just_pressed('tool_backward'):
		var dir = Input.get_axis("tool_backward", "tool_forward")
		#👌Changes current_tool from(0,1,2,3,4,5) and repeat instead of crashing cause went to 6 or -1 (posmod IMPORTANT for going from 0-5 and down)
		current_tool = posmod(current_tool + int(dir), Enum.Tool.size()) as Enum.Tool
		tool_ui.move_Tool_selector(current_tool)

	if Input.is_action_just_pressed('seed_forward'):
		current_seed = posmod (current_seed + 1, Enum.Seed.size()) as Enum.Seed
		tool_ui.move_Seed_selector(current_seed)

	if Input.is_action_just_pressed("action"):
		tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS[current_tool])
		$Animation/AnimationTree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		

func move():
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	move_and_slide()

func animate():
	if direction:
		move_state_machine.travel('Walk')
		var direction_animation = Vector2(round(direction.x),round(direction.y))
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", direction_animation)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position",direction_animation)
		for animation in Data.TOOL_STATE_ANIMATIONS.values():
			var animation_name: String = "parameters/ToolStateMachine/"+ animation +"/blend_position"
			$Animation/AnimationTree.set(animation_name,direction_animation)
	else:
		move_state_machine.travel('Idle')

func tool_target_emit():
	tool_target.emit(current_tool, position + last_direction * TILE_SIZE + DEFAULT_TARGET_POSITION)

func tool_use_emit():
	tool_use.emit(current_tool, position + last_direction * TILE_SIZE + DEFAULT_TARGET_POSITION)

func _on_animation_tree_animation_started(_anim_name: StringName) -> void:
	can_move = false

func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	can_move = true
