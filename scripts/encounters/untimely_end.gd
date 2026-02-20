extends Encounter

var death_cause: String

func hero_is_finished(how: String):
	get_parent().hero_is_finished(how)

func dying_message(msg: String, cause: String):
	title = "You died"
	text = msg
	choices = {"Whatever": _done}
	
	death_cause = cause

func _done():
	hero_is_finished(' has died of ' + death_cause)


func get_lost():
	title = "You are lost"
	text = 'You are completely lost. You have not seen another human for years. Sometimes you kinda forgot here are other humans'

	choices = {
		"Keep on wandering": _wander_more,
		'Become a Yetti': _become_yetti,
		'Give up': _give_up,
	}
	
	trigger()
	
func _become_yetti():
	print('Screw it, you never wanted to be a civilized human anyway. You heed the call of the woods and became a wild man.')
	hero_is_finished(' vanished into woods and became a Yetti')

func _give_up():
	print('You kinda just lie down and stay where youy are. Its not bad place, but it kinda limits heroic opportunities.')
	hero_is_finished(' got lost and gave up.')
	
func _wander_more():
	var how_long = randi_range(1,6)
	print('You wandered {0} years, and finally found your bearings'.format([how_long]))
	#news.emit('Wandering', $StatPanel.hero_name + ' got lost. He was not seen for {0} years'.format([how_long]))
	#time_passes.emit(how_long, 2)
	#news.emit('Wandering', $StatPanel.hero_name + ' emerged from the wilderness')
	$StatPanel.age += how_long
	$StatPanel.add_trait('Wanderer')

	var found_on = Vector2i(randi_range(3, 12), randi_range(1, 6))
	%Horse.my_pos = found_on
	%Horse.global_position = %Map.map2pos(found_on)
	%Map.reveal(found_on)

		
			
