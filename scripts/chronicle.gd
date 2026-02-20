extends Button

signal new_chronicle_event

# TODO: use made-up names (or loosely translate the czech names)?
#const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
const months = ["Frozen", "Hungry", "Nascent", "Growing", "Flowering", "Longest", "Drying", "Harvest", "Twilight", "Bellowing", "Falling", "Praying"]
const book_panel_scene = preload("res://book_panel.tscn")

var events: Array[Array] = [
	# ["event type", year, month, "event text"]
]

var current_year = 917 
var current_month = 11
var hero_name = "Unknown Hero"


func generate_text() -> String:
	var event_text = ""
	for event in events:
		event_text += ("In the " + str(months[event[2]]) + " of " + str(event[1]) + ", " + event[3] + ". \n")
	return event_text

func _on_pressed() -> void:
	$NewFlag.hide()
	
	var book = book_panel_scene.instantiate()
	book.title = "Chronicle of the realm"
	book.text = generate_text()

	# Not storing the dict in typed variable throws
	# "Invalid assignment of property or key 'choices' with value of type 'Dictionary' on a base object of type 'TextureRect (BookPanel)'."
	# WTF
	# I think you cannot assign untyped dict to typed-dict variable, no autoconversion
	var choices: Dictionary[String, Callable] = {"Close": _dummy}
	book.choices = choices
	
	# The book node is Control-derived. This means it can't position itself if its parent
	# isn't a Control-derived node.
	%PopupUILayer.add_child(book)
	%PopupUILayer.show()
	
	
func ingame_event(type, event_text):
	events.append([type, current_year, current_month, event_text])
	$NewFlag.show()
	new_chronicle_event.emit()

func _dummy():
	pass


func _on_test_choice(type: String, event_text: String) -> void:
	ingame_event(type, event_text)

func _on_game_news(type: String, event_text: String) -> void:
	ingame_event(type, event_text)

func _on_horse_reached_tile(_pos: Vector2i) -> void:
	if (current_month + 1) >= len(months):
		current_year += 1
		current_month = 0
	else:
		current_month += 1


func _on_time_passes(years: int, moons: int) -> void:
	current_month += moons
	current_year += years
	if current_month >= len(months):
		current_month -= len(months)
		current_year += 1
