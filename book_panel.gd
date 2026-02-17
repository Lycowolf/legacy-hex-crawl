@tool

extends TextureRect
class_name BookPanel

const BUTTON_SCENE = preload("res://book_button.tscn")
const BUTTON_HOR_OFFSET = 1612
const BUTTON_HOR_PITCH = 7;
const BUTTON_VERT_OFFSET = 128
const BUTTON_VERT_PITCH = 130;
const PAGE_LEN = 450

var current_buttons: Array[BookButton] = []
@export var choices : Dictionary[String, Callable]:
	get: return choices
	set(value):
		choices = value
		if is_node_ready():
			generate_choice_buttons()

@export var title: String:
	set(value):
		title = value
		if is_node_ready():
			reflow_text()
@export_multiline var text: String:
	set(value):
		text = value
		if is_node_ready():
			reflow_text()

func _init() -> void:
	# just for the demo & testing
	if Engine.is_editor_hint():
		choices = {"Test1": _on_book_button_pressed, "Test long text": _on_book_button_pressed}

func _ready() -> void:
	generate_choice_buttons()
	reflow_text()
	set_global_position(Vector2i(60, 38), true)

func generate_choice_buttons():
	for button in current_buttons:
		button.queue_free()
	current_buttons = []
	var i = 0
	for choice_text in choices:
		var button = BUTTON_SCENE.instantiate()
		button.text = choice_text
		current_buttons.append(button)
		button.position = Vector2i(
			BUTTON_HOR_OFFSET + i * BUTTON_HOR_PITCH, 
			BUTTON_VERT_OFFSET + i * BUTTON_VERT_PITCH
		)
		print(choices)
		button.set_listener(choices[choice_text])
		button.set_listener(_on_book_button_pressed)
		add_child(button)
		i += 1

# TODO: real pagination
func reflow_text():
	$Title.text = title
	if len(text) < PAGE_LEN:
		$TextLeft.text = text
		$TextRight.text = 'blah blah blah marginalia'
	else:
		var word_break = text.find(' ', PAGE_LEN)
		$TextLeft.text = text.substr(0, word_break)
		$TextRight.text = text.substr(word_break+1)

func _on_book_button_pressed() -> void:
	queue_free()
	get_parent().hide()
