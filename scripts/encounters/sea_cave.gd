@tool
extends Encounter

func _init():
	title = 'Cave on the shore'
	text = 'While searching a cave on the sea shore, you found a glowy magical pearl. It looks precious.'
	
	choices = {
		'Yoink, a treasure': loot,
		'Eat it': eat,
		'No touching': leave,
	}
	
func loot():
	%StatPanel.add_trait('Magic Pearl')
	trigger_message_add('You carefully pocket the treasure and go on your way')
	news.emit('loot', %StatPanel.hero_name + ' has found magical pearl in a sea cave.')
	delete_encounter()

func eat():
	%StatPanel.add_trait('Merfolk')
	trigger_message_add('The pearl looks delicious, somehow. You swallow it before thinking too much.' +\
	'\nSuddenly, scales start to grow on your body, and fins as well. You turned into one of merfolk!' +\
		'\n\nNOTE: Merfolk can swim, but quickly get thirsty outside water.')
	news.emit('loot', %StatPanel.hero_name + " has eaten what he shouldn't and become a sea creature.")
	delete_encounter()

func leave():
	text += '\n\nThis looks suspicious, you do not touch anything and leave'
	choices = {'Leave': %Horse.go_back}
	sleep_encounter()
	trigger()
		
