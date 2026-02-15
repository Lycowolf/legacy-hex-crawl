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

func is_accessible(pos: Vector2i, walk : bool =true, swim : bool =false, fly : bool =false):
	var gnd_data = $Ground.get_cell_tile_data(pos)
	var wtr_data = $WaterAndRoads.get_cell_tile_data(pos)
	
	var needs_swim = wtr_data and wtr_data.get_custom_data('need_swim')
	var can_walk = gnd_data and gnd_data.get_custom_data('walk')
	
	if not gnd_data:
		return false
	
	if fly:
		return true
		
	if can_walk and needs_swim:
		return swim
		
	return can_walk and walk

func fog_everywhere():
	const FOG = Vector2i(14, 3)
	
	for pos in $Ground.get_used_cells():
		$FogOfWar.set_cell(pos, 0, FOG)

func reveal(pos: Vector2i, size=1):
	$FogOfWar.erase_cell(pos)
	if size > 0:
		for neighbor in $FogOfWar.get_surrounding_cells(pos):
			reveal(neighbor, size-1)
