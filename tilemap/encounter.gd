@tool

extends Node2D
class_name Encounter

@export var title: String
@export var text: String

const marker_scene = preload("res://tilemap/encounter_marker.tscn")

func _ready() -> void:
	if Engine.is_editor_hint():
		var marker = marker_scene.instantiate()
		add_child(marker)
