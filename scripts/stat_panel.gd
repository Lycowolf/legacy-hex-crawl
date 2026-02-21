extends NinePatchRect

var stat_label_settings = preload("res://stat_label_settings.tres")

@onready var name_label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/NameLabel
@onready var age_label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/AgeLabel
@onready var step_label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/StepLabel
@onready var trait_list = $MarginContainer/VBoxContainer/MarginContainer/TraitContainer
@onready var land_list = $MarginContainer/VBoxContainer/MarginContainer2/LandContainer

@onready var conditions : Dictionary[String, ConditionWidget]

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
	
	for child in $MarginContainer/VBoxContainer.get_children():
		if child is ConditionWidget:
			conditions[child.condition_name] = child

func reset():
	steps = 0
	
	for con in conditions:
		conditions[con].value = 0
	
	traits = []
	
func _on_horse_reached_tile(tile: Vector2i) -> void:
	age += 1
	steps += 1
	
	land_traits = %Map.land_at(tile)
	terms_and_conditions(land_traits)

func terms_and_conditions(land):
	if traits.has('Merfolk'):
		if not land.has('Water'):
			conditions['Thirst'].value += 1		
	else:
		if not land[0] == ('Desert'):
			conditions['Thirst'].value -= 1
	
	if land[0] == 'Desert':
			conditions['Thirst'].value += 1
	
	if land.has('Water'):
		conditions['Thirst'].value = 0
	
	if land[0] in ['Forest', 'Tundra', 'Mountains']:
		if not land.has('Road'):
			conditions['Lost'].value += 1
		else:
			conditions['Lost'].value -= 1
	else:
		conditions['Lost'].value = 0
	
	if land[0] == 'Swamp':
		conditions['Poison'].value += 1

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

func add_trait(new_trait: String):
	traits.append(new_trait)
	update_traits()
