extends Node

signal news(type: String, text: String)
signal time_passes(years: int, months: int)

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

func hero_is_finished(how: String):
	news.emit('Funeral', %StatPanel.hero_name + how)
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
	hero_is_finished(' has died of button press')

func _on_condition_critical(condition: String) -> void:
	%Horse.walking = false
			
	match condition:	
		'Thirst', 'Poison':
			$UntimelyEnds.dying_message('You died of ' + condition.to_lower(), condition)
		'Lost':
			%StatPanel.conditions['Lost'].value = 0
			#$UntimelyEnds.get_lost() TODO still not working
			print('You are hopelessly lost')
		
			var book = load("res://book_panel.tscn").instantiate()
			book.title = "You are lost"
			book.text = 'You are completely lost. You have not seen another human for years. Sometimes you kinda forgot here are other humans'

			var choices: Dictionary[String, Callable] = {
				"Keep on wandering": _wander_more,
				'Become a Yetti': _become_yetti,
				'Give up': _give_up,
				}
			book.choices = choices
			
			%PopupUILayer.add_child(book)
			%PopupUILayer.show()

func _wander_more():
	var how_long = randi_range(1,6)
	print('You wandered {0} years, and finally found your bearings'.format([how_long]))
	news.emit('Wandering', $StatPanel.hero_name + ' got lost. He was not seen for {0} years'.format([how_long]))
	time_passes.emit(how_long, 2)
	news.emit('Wandering', $StatPanel.hero_name + ' emerged from the wilderness')
	$StatPanel.age += how_long
	$StatPanel.traits.append('Wanderer')
	$StatPanel.update_traits()
	var found_on = Vector2i(randi_range(3, 12), randi_range(1, 6))
	%Horse.my_pos = found_on
	%Horse.global_position = %Map.map2pos(found_on)
	%Map.reveal(found_on)

func _become_yetti():
	print('Screw it, you never wanted to be a civilized human anyway. You heed the call of the woods and became a wild man.')
	hero_is_finished(' vanished into woods and became a Yetti')

func _give_up():
	print('You kinda just lie down and stay where youy are. Its not bad place, but it kinda limits heroic opportunities.')
	hero_is_finished(' got lost and gave up.')
