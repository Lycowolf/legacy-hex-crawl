extends NinePatchRect

var stat_label_settings = load("res://stat_label_settings.tres")

@onready var name_label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/NameLabel
@onready var age_label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/AgeLabel
@onready var step_label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/StepLabel
@onready var trait_list = $MarginContainer/VBoxContainer/MarginContainer/TraitContainer
@onready var land_list = $MarginContainer/VBoxContainer/MarginContainer2/LandContainer

var traits = [] :
	set(x):
		traits = x
		update_traits()
		
var land_traits = [] :
	set(x):
		land_traits = x
		update_land()

var hero_name : String:
	set(x):
		hero_name = x
		name_label.text = x
var age: int:
	set(x):
		age = x
		age_label.text = str(x)
var steps: int:
	set(x):
		steps = x
		step_label.text = str(x)

func _ready() -> void:
	reset() # TODO move to main game init

func reset():
	hero_name = ['George', 'Ringo', 'Paul', 'John'].pick_random()
	age = randi_range(15, 25)
	steps = 0
	
	traits = ['Beginner\'s luck', 'Folly of youth']
	land_traits = ['Starting spot']
	
func _on_horse_reached_tile(tile: Vector2i) -> void:
	age += 1
	steps += 1
	
	land_traits = %Map.land_at(tile)

func update_traits():
	for child in trait_list.get_children():
		child.queue_free()
	
	for trt in traits:
		var label = Label.new()
		label.text = trt
		label.label_settings = stat_label_settings
		trait_list.add_child(label)

func update_land():
	for child in land_list.get_children():
		child.queue_free()
		
	for land_trait in land_traits:
		var label = Label.new()
		label.text = land_trait
		label.label_settings = stat_label_settings
		land_list.add_child(label)

func check_trait(target_trait: String, _difficulty: int):
	return traits.has(target_trait)

func check_land(target_trait: String):
	return land_traits.has(target_trait)
