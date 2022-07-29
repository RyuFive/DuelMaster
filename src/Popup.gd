extends MarginContainer

onready var root = get_node("/root/Playspace")
onready var monster = get_node("../../../Monster1/Cards")

var options = ['Summon', 'Cast', 'Attack', 'Send to Mana']
var methods = ['summon', 'cast', 'attack', 'mana']
var card

func _ready():
	var source = str(get_node('../../'))
	
	var type = card.cardData.type
	if 'Monster' in source:
		removeOption([3, 1, 0])
	elif type == 'Spell' and 'Hand' in source:
		removeOption([2, 0])
	elif type == 'Creature' and 'Hand' in source:
		removeOption([2, 1])
		if monster.get_child_count() == 5:
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
	root.hand2monster(card)
	removeSelf()

func cast():
	root.hand2grave(card)
	removeSelf()

func attack():
	removeSelf()

func mana():
	root.hand2mana(card)
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
