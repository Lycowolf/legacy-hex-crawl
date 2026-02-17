extends NinePatchRect

var hero_name : String:
	set(x):
		hero_name = x
		$NameLabel.text = x.to_lower()
var age: int:
	set(x):
		age = x
		$AgeLabel.text = str(x)
var steps: int:
	set(x):
		steps = x
		$StepLabel.text = str(x)

func _ready() -> void:
	reset() # TODO move to main game init

func reset():
	hero_name = ['George', 'Ringo', 'Paul', 'John'].pick_random()
	age = randi_range(15, 25)
	steps = 0

func _on_horse_reached_tile() -> void:
	age += 1
	steps += 1
