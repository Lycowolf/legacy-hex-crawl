extends NinePatchRect

# TODO: use made-up names (or loosely translate the czech names)?
const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
const page_len = 450

var events: Array[Array] = [
	# ["event type", year, month, "event text"]
	["one_time", 917, 0, "The Warlock came into the realm"],
	["one_time", 917, 1, "The Warlock cast a curse upon the realm, souring the rivers, choking the sky with ash and bringing all kinds of hardship on all people"],
	["one_time", 917, 2, "an Unknown Hero rose against the warlock but coulnd't prevail against The Warlock's magic"],
	["one_time", 917, 3, "The Warlock sailed a ship through the sea in a search for a thing known only to them"],
	["one_time", 917, 4, "The Warlock built a mile high tower out of shinig quartz and black glass in the far northeast and settled there"],
	["one_time", 917, 6, "The Warlock raised a ring of mountains around their tower, so high and steep no one could scale them"],
	["one_time", 917, 8, "The Warlock laid waste to the nearby lands, turning them into a desert that would kill even the toughest traveller"],
	["one_time", 917, 9, "The Warlock commanded a mighty dragon to guard the desert"],
]

var current_date = [917, 11]


func add_event(year, month, text):
		$Text.append_text("In the " + months[month] + " of " + str(year) + ", " + text + ".\n\n")


func _ready() -> void:
	$Text.text = ""
	for event in events:
		add_event(event[1], event[2], event[3])
