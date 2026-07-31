extends Control

const TOOL_TEXTURES = {
	Enum.Tool.AXE: preload("res://graphics/icons/axe.png"),
	Enum.Tool.HOE: preload("res://graphics/icons/hoe.png"),
	Enum.Tool.WATER: preload("res://graphics/icons/water.png"),
	Enum.Tool.SWORD: preload("res://graphics/icons/sword.png"),
	Enum.Tool.FISH: preload("res://graphics/icons/fish.png"),
	Enum.Tool.SEED: preload("res://graphics/icons/wheat.png"),
}

var tool_texture_scene = preload("res://scenes/UI/tool_ui_texture.tscn")

func _ready() -> void:
	texture_setup(Enum.Tool.values(), TOOL_TEXTURES, $"Tool container")
	await get_tree().process_frame
	move_selector_to_slot(0)

func texture_setup(enum_list: Array, textures: Dictionary, container: HBoxContainer) -> void:
	for enum_id in enum_list:
		var tool_texture = tool_texture_scene.instantiate()
		tool_texture.setup(enum_id, textures[enum_id])
		container.add_child(tool_texture)
		

func move_selector_to_slot(slot_index: int) -> void:

	var active_slot_node = $"Tool container".get_child(slot_index)
	var padding := 8
	
	var target_position = active_slot_node.global_position + Vector2(padding, padding)
	var target_size = active_slot_node.size - Vector2(padding * 2, padding * 3)
	
	$SelectionFrame.custom_minimum_size = target_size
	$SelectionFrame.size = target_size
	
	var tween = create_tween()
	
	tween.tween_property($SelectionFrame, "global_position", target_position, 0.15)
	
	
