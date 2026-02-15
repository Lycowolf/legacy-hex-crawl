@tool

extends TextureRect

signal choice(index: int)

const BUTTON_SCENE = preload("res://book_button.tscn")
const BUTTON_HOR_OFFSET = 1612
const BUTTON_HOR_PITCH = 7;
const BUTTON_VERT_OFFSET = 128
const BUTTON_VERT_PITCH = 130;
const PAGE_LEN = 450

var current_buttons: Array = []

@export var choices : Array[String]:
	get: return choices
	set(value):
		choices = value
		generate_choice_buttons()

func _ready() -> void:
	generate_choice_buttons()

func generate_choice_buttons():
	for button in current_buttons:
		button.queue_free()
	current_buttons = []
	for i in range(0, len(choices)):
		var button = BUTTON_SCENE.instantiate()
		button.text = choices[i]
		current_buttons.append(button)
		button.position = Vector2i(
			BUTTON_HOR_OFFSET + i * BUTTON_HOR_PITCH, 
			BUTTON_VERT_OFFSET + i * BUTTON_VERT_PITCH
		)
		add_child(button)

func trigger_encounter(encounter: Encounter):
	show_encounter(encounter.title, encounter.text)

func show_encounter(title, text):
	$Title.text = title
	if len(text) < PAGE_LEN:
		$TextLeft.text = text
		$TextRight.text = 'blah blah blah marginalia'
	else:
		var word_break = text.find(' ', PAGE_LEN)
		$TextLeft.text = text.substr(0, word_break)
		$TextRight.text = text.substr(word_break+1)
	show()
	%Map.disabled = true

func _on_close_button_pressed() -> void:
	hide()
	%Map.disabled = false
