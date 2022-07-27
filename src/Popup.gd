extends MarginContainer

var options = ['Summon', 'Cast', 'Attack', 'Send to Mana']
var methods = ['summon', 'cast', 'attack', 'mana']
var card

func _ready():
	if str(card.get_parent().get_parent()).find('Monster') > -1:
		removeOption([3, 1, 0])
	elif card.cardData.type == 'Spell' and str(card.get_parent().get_parent()).find('Card') > -1:
		removeOption([2, 0])
	elif card.cardData.type == 'Creature' and str(card.get_parent().get_parent()).find('Card') > -1:
		removeOption([2, 1])
		if get_node('../../../Monster1/HBox').get_child_count() == 5:
			removeOption([0])
		
	rect_size = Vector2(176, int(len(options)/4)*160)
	$BG/VBox.rect_min_size = Vector2(176, int(len(options)/4)*160)
	$BG/VBox.rect_size = Vector2(176, int(len(options)/4)*160)
	
	$BG.texture = load(str("res://assets/zone/popup", len(options), '.png'))
	for i in options.size():
		if options.size() == 1:
			$BG/VBox/Option3.text = options[0]
			$BG/VBox/Option3.visible = true
			break
		$BG/VBox.get_child(i).text = options[i]
		$BG/VBox.get_child(i).visible = true

func summon():
	$'../../../'.hand2monster(card)
	print('Summoned ', card.cardName)
	removeSelf()

func cast():
	$'../../../'.hand2grave(card)
	print('Casting ', card.cardName)
	removeSelf()

func attack():
	print('Attacking with ', card.cardName)
	removeSelf()

func mana():
	$'../../../'.hand2mana(card)
	print('Sending ', card.cardName, ' to mana')
	removeSelf()

func removeSelf():
	$'../'.remove_child(self)

func _on_Option1_pressed():
	var funcCall = funcref(self, methods[0]);
	funcCall.call_func()

func _on_Option2_pressed():
	var funcCall = funcref(self, methods[1]);
	funcCall.call_func()

func _on_Option3_pressed():
	var funcCall = funcref(self, methods[0]);
	funcCall.call_func()

func removeOption(num):
	for i in num:
		options.remove(i)
		methods.remove(i)
