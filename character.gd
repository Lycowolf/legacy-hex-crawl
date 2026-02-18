extends AnimatedSprite2D

signal reached_tile

@onready
var map = %Map
var target_path: Array[Vector2i]
var my_pos: Vector2i
var last_pos: Vector2i
var speed = 150.0
var walking: bool:
	set(val):
		walking = val
		if val:
			self.play('walk')
		else:
			self.play('stand')

func _ready() -> void:
	my_pos = map.pos2map(self.global_position)
	last_pos = my_pos
	target_path = []

func _process(delta: float) -> void:
	if walking:
		var target = map.map2pos(target_path[0])
		
		# set sprite facing
		if target.x > position.x:
			flip_h = false
		if target.x < position.x:
			flip_h = true
	
		var new_position = position.move_toward(target, delta * speed)
		if map.pos2map(new_position)  != map.pos2map(position):
			on_reached_border(map.pos2map(position), map.pos2map(new_position))
		
		position = new_position
		
		if position == target:
			on_reached_tile(target_path[0])

func go_back():
	if walking:
		target_path = [my_pos]
	else:
		target_path = [last_pos]
	

@warning_ignore("unused_parameter")
func _on_map_tile_click(map_pos: Vector2i, button: MouseButton) -> void:
	if walking:
		print('Wait, Im still walking')
		$Reaction.play("dude")
		return
		
	var path = map.find_path(self.my_pos, map_pos)
	if path:  
		self.target_path = path
		walking = true
	else:
		print('Too far')
		$Reaction.play("nope")

@warning_ignore("unused_parameter")
func on_reached_border(old_pos: Vector2i, new_pos: Vector2i):
	if not %Map.is_accessible(new_pos, true):
		print('Too scary, not going')
		go_back()

func on_reached_tile(tile_pos: Vector2i):	
	last_pos = my_pos
	my_pos = tile_pos
	target_path.pop_front()
	walking = not target_path.is_empty()
	%Map.reveal(my_pos, 1)
	reached_tile.emit(tile_pos)
	
	var encounters = map.get_encounters(tile_pos)
	for encounter in encounters:
		encounter.trigger()
	
	# encounter might also trigger:
	#	go_back()
