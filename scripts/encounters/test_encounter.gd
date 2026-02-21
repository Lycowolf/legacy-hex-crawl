@tool

extends Encounter

func _init() -> void:
	choices = {"Choice 1": _on_test1, "Take 2": _on_test2}
	
func _on_test1():
	news.emit("one_time", "chose 1")
	print("Chosen 1!")
	
func _on_test2():
	news.emit("one_time", "chose 2")
	print("Chosen 2!")
