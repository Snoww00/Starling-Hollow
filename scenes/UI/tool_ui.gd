extends Control

const TOOL_TEXTURES = {
	Enum.Tool.HAND: preload("res://graphics/icons/hand.png"),
	Enum.Tool.AXE: preload("res://graphics/icons/axe.png"),
	Enum.Tool.HOE: preload("res://graphics/icons/hoe.png"),
	Enum.Tool.WATER: preload("res://graphics/icons/water.png"),
	Enum.Tool.SWORD: preload("res://graphics/icons/sword.png"),
	Enum.Tool.FISH: preload("res://graphics/icons/fish.png"),
	Enum.Tool.SEED: preload("res://graphics/icons/wheat.png"),}
const SEED_TEXTURES = {
	Enum.Seed.CORN: preload("res://graphics/icons/corn.png"),
	Enum.Seed.PUMPKIN: preload("res://graphics/icons/pumpkin.png"),
	Enum.Seed.TOMATO: preload("res://graphics/icons/tomato.png"),
	Enum.Seed.WHEAT: preload("res://graphics/icons/wheat.png")}

var tool_texture_scene = preload("res://scenes/UI/tool_ui_texture.tscn")

func _ready() -> void:
	texture_setup(Enum.Tool.values(), TOOL_TEXTURES, $"Tool container")
	texture_setup(Enum.Seed.values(), SEED_TEXTURES, $"Seed container")
	await get_tree().process_frame
	move_Tool_selector(0)
	move_Seed_selector(0)
	

func texture_setup(enum_list: Array, textures: Dictionary, container: HBoxContainer) -> void:
	for enum_id in enum_list:
		var tool_texture = tool_texture_scene.instantiate()
		tool_texture.setup(enum_id, textures[enum_id])
		container.add_child(tool_texture)
		

func move_Tool_selector(slot_index: int) -> void:

	var active_slot_node = $"Tool container".get_child(slot_index)
	var padding := 8
	
	var target_position = active_slot_node.global_position + Vector2(padding, padding)
	var target_size = active_slot_node.size - Vector2(padding * 2, padding * 3)
	
	$ToolSelectionFrame.custom_minimum_size = target_size
	$ToolSelectionFrame.size = target_size
	
	var tween = create_tween()
	
	tween.tween_property($ToolSelectionFrame, "global_position", target_position, 0.15)
	
func move_Seed_selector(slot_index: int) -> void:

	var active_slot_node = $"Seed container".get_child(slot_index)
	var padding := 8
	
	var target_position = active_slot_node.global_position + Vector2(padding, padding)
	var target_size = active_slot_node.size - Vector2(padding * 2, padding * 3)
	
	$SeedSelectionFrame.custom_minimum_size = target_size
	$SeedSelectionFrame.size = target_size
	
	var tween = create_tween()
	
	tween.tween_property($SeedSelectionFrame, "global_position", target_position, 0.15)
	
	
