extends Node2D

signal tile_click

var disabled : bool = false

var encounters: Dictionary

func _ready() -> void:
	# build encounter index
	for child in $Encounters.get_children():
		var pos = pos2map(child.global_position)
		if not encounters.has(pos):
			encounters[pos] = []
		encounters[pos].append(child)

func _input(event: InputEvent) -> void:
	if !disabled and event is InputEventMouseButton:
		var bevent = event as InputEventMouseButton
		if bevent.pressed:  # and map_pos is valid
			#on_map_click(pos2map(bevent.position), bevent.button_index)
			emit_signal('tile_click', pos2map(bevent.position), bevent.button_index)

func pos2map(global_pos: Vector2):
	return $Ground.local_to_map($Ground.to_local(global_pos))

func map2pos(map_pos: Vector2i):
	return $Ground.to_global($Ground.map_to_local(map_pos)) 

func find_path(start: Vector2i, end: Vector2i):
	if end in $Ground.get_surrounding_cells(start):
		return [end]
	else:
		return []

func get_encounters(pos: Vector2i):
	return encounters.get(pos, [])
