extends StaticBody2D
var coord: Vector2i
@export var res: PlantResource

func setup(grid_coord:Vector2i , parent: Node2D, new_res: PlantResource):
	position = grid_coord * Data.TILE_SIZE + Vector2i(8,5)
	parent.add_child(self)
	coord= grid_coord
	res = new_res
	$Sprite2D.texture = res.texture

func grow(watered:bool):
	if watered:
		res.grow($Sprite2D)
	else:
		res.decay(self)

func is_ready_to_harvest() -> bool:
	if res:
		return res.get_complete()
	return false
