extends AnimatedSprite2D

@onready
var map = %Ground
var target_pos: Vector2i
var my_pos: Vector2i
var speed = 60.0
var walking: bool:
	set(val):
		walking = val
		if val:
			self.play('walk')
		else:
			self.play('stand')

func _ready() -> void:
	my_pos = pos2map(self.global_position)
	target_pos = my_pos

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var bevent = event as InputEventMouseButton
		if bevent.pressed:  # and map_pos is valid
			on_map_click(pos2map(bevent.position), bevent.button_index)

func _process(delta: float) -> void:
	if walking:
		var target = map2pos(target_pos)
		
		# set sprite facing
		if target.x > position.x:
			flip_h = false
		if target.x < position.x:
			flip_h = true
	
		var new_position = position.move_toward(target, delta * speed)
		if pos2map(new_position)  != pos2map(position):
			on_reached_border(pos2map(position), pos2map(new_position))
		
		position = new_position
		
		if position == target:
			on_reached_tile(target_pos)

func go_back():
	if not walking:
		return
	
	target_pos = my_pos

func on_map_click(map_pos: Vector2i, button: MouseButton):
	if walking:
		print('Wait, Im still walking')
		return
		
	if map_pos in map.get_surrounding_cells(self.my_pos):
		self.target_pos = map_pos
		walking = true
		
	else:
		print('Too far')

func on_reached_border(old_pos: Vector2i, new_pos: Vector2i):
	print('Halfway there')
	
	#if tile_not_accessible()
		#print('Too scary, not going')
		#go_back()

func on_reached_tile(tile_pos: Vector2i):
	print('Here we are')
	
	# var result = do_encounter()
	# if result.stay:
	my_pos = target_pos
	walking = false
	#else:
	#	go_back()

func pos2map(global_pos: Vector2):
	return map.local_to_map(map.to_local(global_pos))

func map2pos(map_pos: Vector2i):
	return map.to_global(map.map_to_local(map_pos)) 
