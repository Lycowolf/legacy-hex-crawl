extends Node2D

signal news(type: String, text: String)
signal time_passes(years: int, months: int)

const event_display_secs = 2.0
const popup_scene = preload("res://pop_up_box.tscn")

var sequence: Array[Array] = [] # items: [duration_sec, func_to_call, array_of_params]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: animations of what's happening
	const game_start_events = [
		["The Warlock came into the realm"],
		["The Warlock cast a curse upon the realm, souring the rivers, choking the sky with ash and bringing all kinds of hardship on all people"],
		["An Unknown Hero rose against the warlock but coulnd't prevail against The Warlock's magic"],
		["The Warlock sailed a ship through the sea in a search for a thing known only to them"],
		["The Warlock built a mile high tower out of shining quartz and black glass in the far northeast and settled there"],
		["The Warlock raised a ring of mountains around their tower, so high and steep no one could scale them"],
		["The Warlock laid waste to the nearby lands, turning them into a desert that would kill even the toughest traveller"],
		["The Warlock commanded a mighty dragon to guard the desert"],
	]
	for ev in game_start_events:
		var duration = 1.0 + 0.05 * len(ev[0])
		sequence.append([duration, chronicle_event, ev])
	run()
	

func chronicle_event(event_desc: Array) -> Callable:
	var ev_text = event_desc[0]
	%PopupUILayer.show()
	var displayed_event = popup_scene.instantiate()
	displayed_event.get_child(0).text = ev_text # FIXME: abstraction
	%PopupUILayer.add_child(displayed_event)
	news.emit("one_time", ev_text)
	time_passes.emit(0, 1)
	return func(): displayed_event.queue_free()


## Execute a previously defined sequence.
## The sequence is an array of events, every event is an array containing (in order):
## duration: how long should the event be displayed
## setup callable: it will be called to display the event. It shall return a cleanup callable.
## args array: will be passed (as a single argument) to the setup callable
# TODO: maybe get rid of duration and cleanup callable, make the setup callable a coroutine and leave the work to it?
func run() -> void:
	for event in sequence:
		var duration: float = event[0]
		var setup: Callable = event[1]
		var args: Array = event[2]
		$Timer.start(duration)
		var cleanup: Callable = setup.call(args)
		await $Timer.timeout
		cleanup.call()
