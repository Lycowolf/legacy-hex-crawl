@tool

extends Encounter

signal choice(type: String, text: String)

func _init() -> void:
	choices = {"Choice 1": _on_test1, "Take 2": _on_test2}
	
func _on_test1():
	choice.emit("one_time", "chose 1")
	print("Chosen 1!")
	
func _on_test2():
	choice.emit("one_time", "chose 2")
	print("Chosen 2!")
