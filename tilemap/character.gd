extends AnimatedSprite2D

@onready
var map = %Map
var target_pos: Vector2i
var my_pos: Vector2i
var last_pos: Vector2i
var speed = 60.0
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
	target_pos = my_pos

func _process(delta: float) -> void:
	if walking:
		var target = map.map2pos(target_pos)
		
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
			on_reached_tile(target_pos)

func go_back():
	if walking:
		target_pos = my_pos
	else:
		target_pos = last_pos
	

func _on_map_tile_click(map_pos: Vector2i, button: MouseButton) -> void:
	if walking:
		print('Wait, Im still walking')
		$Reaction.play("dude")
		return
		
	var path = map.find_path(self.my_pos, map_pos)
	if path:  
		self.target_pos = path[0] # just one step for now
		walking = true
	else:
		print('Too far')
		$Reaction.play("nope")

func on_reached_border(old_pos: Vector2i, new_pos: Vector2i):
	if not %Map.is_accessible(new_pos, true):
		print('Too scary, not going')
		go_back()

func on_reached_tile(tile_pos: Vector2i):	
	last_pos = my_pos
	my_pos = target_pos
	walking = false
	
	var encounter = map.get_encounters(tile_pos)
	if encounter:
		%EncounterPanel.trigger_encounter(encounter[0])
	
	# encounter might also trigger:
	#	go_back()
