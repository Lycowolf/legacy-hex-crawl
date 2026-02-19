@tool

extends TextureRect
class_name BookPanel

const BUTTON_SCENE = preload("res://book_button.tscn")
const BUTTON_HOR_OFFSET = 1612
const BUTTON_HOR_PITCH = 7;
const BUTTON_VERT_OFFSET = 128
const BUTTON_VERT_PITCH = 130;

var current_buttons: Array[Button] = []
var bbcode_text: String
@export var pages: Array[String]
@export var current_page: int = 0:
	set(value):
		if not is_node_ready():
			await ready
		
		value = clamp(value, 0, max(len(pages) - 1, 0))
		current_page = value
		$TextLeft.text = pages[value]
		if value + 1 < len(pages):
			$TextRight.text = pages[value + 1]
		else:
			$TextRight.text = ""
		if value == 0:
			$PrevButton.hide()
		else:
			$PrevButton.show()
		if value >= len(pages) - 2:
			$NextButton.hide()
		else:
			$NextButton.show()

@export var choices : Dictionary[String, Callable]:
	get: return choices
	set(value):
		choices = value
		if not is_node_ready():
			await ready
		generate_choice_buttons()
@export var title: String:
	set(value):
		title = value
		if not is_node_ready():
			await ready
		generate_pages()
@export_multiline var text: String:
	set(value):
		text = value
		if not is_node_ready():
			await ready
		generate_pages()

func _init() -> void:
	# just for the demo & testing
	if Engine.is_editor_hint():
		choices = {"Test1": _on_book_button_pressed, "Test long text": _on_book_button_pressed}

func _ready() -> void:
	$TextLeft.text = ""
	$TextRight.text = ""
	generate_choice_buttons()
	generate_pages()
	current_page = 0
	set_global_position(Vector2i(60, 38), true)

func generate_choice_buttons():
	for button in current_buttons:
		button.queue_free()
	current_buttons = []
	var i = 0
	for choice_text in choices:
		var button: Button = BUTTON_SCENE.instantiate()
		button.text = choice_text
		current_buttons.append(button)
		button.position = Vector2i(
			BUTTON_HOR_OFFSET + i * BUTTON_HOR_PITCH, 
			BUTTON_VERT_OFFSET + i * BUTTON_VERT_PITCH
		)
		print(choices)
		button.pressed.connect(_on_book_button_pressed)
		button.pressed.connect(choices[choice_text])
		add_child(button)
		i += 1

func generate_pages():
	pages = []
	var max_height = $TextLeft.size.y
	var unprocessed_text = ("[center][font size=40][b][i]" + title + "[/i][/b][/font][/center]\n" + text).split(" ")
	var current_arr: PackedStringArray = []
	while true:
		if len(current_arr) < len(unprocessed_text): # the other case will get handled by the next "if"
			current_arr.append(unprocessed_text[len(current_arr)]) # add a word
			$TextLeft.text = " ".join(current_arr)
			if $TextLeft.get_content_height() > max_height:
				# we just overflown the max height
				current_arr = current_arr.slice(0, -1) # back off one word
				pages.append(" ".join(current_arr)) # generate page
				unprocessed_text = unprocessed_text.slice(len(current_arr)) # discard processed part
				current_arr = []
		else:
			pages.append(" ".join(current_arr)) # last page
			break
	current_page = 0 # reset paging

func _on_book_button_pressed() -> void:
	queue_free()
	get_parent().hide()


func _on_prev_button_pressed() -> void:
	print("prev")
	current_page -= 2


func _on_next_button_pressed() -> void:
	print("next")
	current_page += 2
