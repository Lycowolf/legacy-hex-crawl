@tool

extends Encounter

signal choice(type: String, text: String)
signal consequence(cause_of_death: String)

func _ready() -> void:
	title = 'A knight on a bridge'
	text = "'You find a bridge, and a knight who guards it. He's annoyingly in the way." + \
	"'\nHey, traveller! he shouts. You must answer three questions to prove your worth." +\
	"\nThe first is ... What is your quest?"
	var quest = ['To see the world', 'To become rich', 'Honor and glory!'].pick_random()
	choices = {quest: _answer1, "I don't know": _dunno}

func _dunno():
	choice.emit("bridge_trial", %StatPanel.hero_name + " couldn't answer and fell to his doom")
	consequence.emit(" died of Monty Python reference")
	
func _answer1():
	choice.emit("bridge_trial", %StatPanel.hero_name + " answered correctly")
	text += "\n\nThe second is ... What's your name?"
	choices = {%StatPanel.hero_name: _answer2, "I don't know": _dunno}
	trigger()
	
func _answer2():
	choice.emit("bridge_trial", %StatPanel.hero_name + " answered correctly again")
	text += "\n\nAnd the third is ... What's your favorite color?"
	var color = ['Blue', '#FF00FF', 'Moss green'].pick_random()
	choices = {color: _answer3, "I don't know": _dunno}
	trigger()

func _answer3():
	choice.emit("bridge_trial", %StatPanel.hero_name + " aced the bridge exam")
	text += "\n\nSatisfied, the knight lets you pass"
	choices = {'Finally': _done}
	trigger()

func _done():
	# remove the encounter
	self.queue_free()
	%PopupUILayer.hide()
