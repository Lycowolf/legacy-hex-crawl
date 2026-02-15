extends AnimatedSprite2D

@onready
var map = %Map
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
	my_pos = map.pos2map(self.global_position)
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
	if not walking:
		return
	
	target_pos = my_pos

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
	print('Halfway there')
	
	#if tile_not_accessible()
		#print('Too scary, not going')
		#go_back()

func on_reached_tile(tile_pos: Vector2i):
	print('Here we are')
	
	trigger_encounter(true)
	# var result = do_encounter()
	# if result.stay:
	my_pos = target_pos
	walking = false
	#else:
	#	go_back()

func trigger_encounter(long: bool):
	if long:	
		%EncounterPanel.show_encounter('Encounter: Latin text',
		'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
	else:
		%EncounterPanel.show_encounter('Encounter: short', '10 cm is not that short generally, but for a snake that is pathetic.')
