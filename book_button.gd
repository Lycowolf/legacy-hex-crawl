@tool

# NOTE: to get a thick(er) frame and clean text rendering we upscale the button 6x,
# hide its text, put a label on it and downscale the label by the same factor

extends MarginContainer
class_name BookButton

@export var text: String:
	set(value):
		text = value
		if is_node_ready():
			set_child_text(value)
			
func _ready() -> void:
	set_child_text(text)

func set_child_text(value):
	$Button.text = value
	$Button/Label.text = value
	var width = $Button/Label.size.x
	size.x = width

func set_listener(listener: Callable):
	$Button.pressed.connect(listener)
	pass
