extends Button

# TODO: use made-up names (or loosely translate the czech names)?
const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
const page_len = 450
const book_panel_scene = preload("res://book_panel.tscn")

var events: Array[Array] = [
	# ["event type", year, month, "event text"]
	["one_time", 917, 0, "The Warlock came into the realm"],
	["one_time", 917, 1, "The Warlock cast a curse upon the realm, souring the rivers, choking the sky with ash and bringing all kinds of hardship on all people"],
	["one_time", 917, 2, "an Unknown Hero rose against the warlock but coulnd't prevail against The Warlock's magic"],
	["one_time", 917, 3, "The Warlock sailed a ship through the sea in a search for a thing known only to them"],
	["one_time", 917, 4, "The Warlock built a mile high tower out of shining quartz and black glass in the far northeast and settled there"],
	["one_time", 917, 6, "The Warlock raised a ring of mountains around their tower, so high and steep no one could scale them"],
	["one_time", 917, 8, "The Warlock laid waste to the nearby lands, turning them into a desert that would kill even the toughest traveller"],
	["one_time", 917, 9, "The Warlock commanded a mighty dragon to guard the desert"],
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
	var book = book_panel_scene.instantiate()
	book.title = "Chronicle of the realm"
	book.text = generate_text()
	# Not storing the dict in typed variable throws
	# "Invalid assignment of property or key 'choices' with value of type 'Dictionary' on a base object of type 'TextureRect (BookPanel)'."
	# WTF
	var choices: Dictionary[String, Callable] = {"Close": _dummy}
	book.choices = choices
	# The book node is Control-derived. This means it can't position itself if its parent
	# isn't a Control-derived node.
	%PopupUILayer.add_child(book)
	%PopupUILayer.show()
	
	
func ingame_event(type, text):
	events.append([type, current_year, current_month, "The " + hero_name + " " + text])

func _dummy():
	pass


func _on_test_choice(type: String, text: String) -> void:
	ingame_event(type, text)


func _on_horse_reached_tile(_pos: Vector2i) -> void:
	if (current_month + 1) >= len(months):
		current_year += 1
		current_month = 0
	else:
		current_month += 1
