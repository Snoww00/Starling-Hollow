extends Node2D

var plant_scene = preload('res://scenes/Objects/plant.tscn')
var used_cells :Array[Vector2i]
@onready var player = $Objects/Player
@onready var day_transition_material = $"CanvasLayer/Day TransitionLayer".material
@export var daytime_color : Gradient

func _ready():
	player.tool_target.connect(_on_player_tool_target)
	
func _on_player_tool_target(tool: Enum.Tool, pos: Vector2) -> void:
	var player_pos = player.position + player.last_direction * 16 + Vector2(0,4)
	var grid_coord: Vector2i = Vector2i(int(player_pos.x / Data.TILE_SIZE),int(player_pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0 
	if tool == Enum.Tool.HAND || tool == Enum.Tool.SWORD:
		$Layers/FeedbackLayer.clear()
	else:
		$Layers/FeedbackLayer.clear()
		$Layers/FeedbackLayer.set_cell(grid_coord, 8 ,Vector2i(4,4))

func _on_player_tool_use(tool: Enum.Tool, pos: Vector2) -> void:
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE),int(pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	var has_soil = grid_coord in $"Layers/Soil Layer".get_used_cells()
	match tool:
		Enum.Tool.HOE:
			var cell = $"Layers/Grass Layer".get_cell_tile_data(grid_coord) as TileData
			if cell and cell.get_custom_data('farmable'):
				$"Layers/Soil Layer".set_cells_terrain_connect([grid_coord], 0, 0)
		Enum.Tool.WATER:
			if has_soil:
				$"Layers/Soil Water Layer".set_cell(grid_coord, 0, Vector2(randi_range(0,2),0))
		Enum.Tool.FISH:
			if not grid_coord in $"Layers/Grass Layer".get_used_cells():
				print('fishing')
		Enum.Tool.SEED:
			if has_soil and grid_coord not in used_cells:
				var plant = plant_scene.instantiate()
				plant.setup(grid_coord, $Objects)
				used_cells.append(grid_coord)
		Enum.Tool.AXE, Enum.Tool.SWORD:
			for object in get_tree().get_nodes_in_group('Objects'):
				if object.position.distance_to(pos) < 20:
					object.hit(tool)
			
func _process(_delta: float) -> void:
	var daytime_point = 1 - ($Timers/DayTimer.time_left / $Timers/DayTimer.wait_time)
	var color = daytime_color.sample(daytime_point)
	$"Overlay/Daytime color".color = color
	if Input.is_action_just_pressed("day_change"):
		day_restart()
	
func day_restart():
	var tween = create_tween()
	tween.tween_property(day_transition_material,"shader_parameter/progress", 1.0 , 1.0)
	tween.tween_interval(0.5)
	tween.tween_callback(level_reset)
	tween.tween_property(day_transition_material,"shader_parameter/progress", 0 , 1.0)

func level_reset():
	$Timers/DayTimer.start()
	for object in get_tree().get_nodes_in_group('Objects'):
		if 'reset' in object:
			object.reset()
