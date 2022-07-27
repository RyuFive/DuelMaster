extends MarginContainer

var options = ['Summon', 'Cast', 'Attack', 'Send to Mana']
var card

func _ready():
	for i in options.size():
		$VBox.get_child(i).text = options[i]

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var select = int(event.position.y / 40)
			if select == 0:
				$'../../../'.hand2monster(card)
				print('Summoned ', card.cardName)
			elif select == 1:
				print('Casting ', card.cardName)
			elif select == 2:
				if str(card.get_parent().get_parent()).find('Monster') > -1:
					print('Attacking with ', card.cardName)
			elif select == 3:
				$'../../../'.hand2mana(card)
				print('Sending ', card.cardName, ' to mana')

			$'../'.remove_child(self)
