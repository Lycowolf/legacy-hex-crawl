@tool

extends Node2D
class_name Encounter

@export var title: String
@export var text: String
var choices: Dictionary[String, Callable] # override in subclasses

const marker_scene = preload("res://encounter_marker.tscn")
const book_panel_scene = preload("res://book_panel.tscn")

func _ready() -> void:
	if not choices:
		choices = {"Close": _on_book_close}
	if Engine.is_editor_hint():
		var marker = marker_scene.instantiate()
		marker.transform = marker.transform.scaled(Vector2(4.0, 4.0))
		add_child(marker)

func trigger_encounter():
	var book = book_panel_scene.instantiate()
	book.title = title
	book.text = text
	book.choices = choices
	# The book node is Control-derived. This means it can't position itself if its parent
	# isn't a Control-derived node.
	%PopupUILayer.add_child(book)

func _on_book_close():
	pass
