extends Node

signal news
signal time_passes

func _ready():
	start_new_cycle()

func start_new_cycle():
	var starting_place = [
		Vector2i(2, 4),
		Vector2i(0, 3), 
		Vector2i(0, 7), 
		Vector2i(5, 2),
		].pick_random()
	
	%Horse.global_position = %Map.map2pos(starting_place)
	%Horse._ready()
	
	%StatPanel.reset()
	%StatPanel.hero_name = ['George', 'Ringo', 'Paul', 'John'].pick_random()
	%StatPanel.age = randi_range(15, 25)
	%StatPanel.traits = ['Beginner\'s luck', 'Folly of youth']
	%StatPanel.land_traits = %Map.land_at(starting_place)
	
	%Map.fog_everywhere()
	%Map.reveal(starting_place)
	
	news.emit('NG+', %StatPanel.hero_name + ' has started his journey')

func hero_is_finished():
	news.emit('Funeral', %StatPanel.hero_name + ' has died to button press')
	update_map()
	play_transition()
	start_new_cycle()

func update_map():
	print('removing ephemeral encounters')
	print('creating the grave of last hero (if dead)')
	print('applying consequences')
	print('progressing long-term events')

func play_transition():
	# show some cool UI
	print('Time passes ...')
	time_passes.emit(randi_range(1, 10), randi_range(1, 12))


func _on_die_button_pressed() -> void:
	hero_is_finished()
