@tool

extends MarginContainer

@export var text: String:
	set(value):
		text = value
		if is_node_ready():
			set_child_text(value)
			
func _ready() -> void:
	set_child_text(text)

func set_child_text(value):
	print(value)
	$Button.text = value
	$Button/Label.text = value
	var width = $Button/Label.size.x
	size.x = width
