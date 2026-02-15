extends TextureRect

var page_len = 450

func show_encounter(title, text):
	$Title.text = title
	if len(text) < page_len:
		$TextLeft.text = text
		$TextRight.text = 'blah blah blah marginalia'
	else:
		var word_break = text.find(' ', page_len)
		$TextLeft.text = text.substr(0, word_break)
		$TextRight.text = text.substr(word_break+1)
	show()
	%Map.disabled = true


func _on_close_button_pressed() -> void:
	hide()
	%Map.disabled = false
