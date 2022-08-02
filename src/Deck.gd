extends Button

onready var root = get_node("/root/Playspace")
onready var deck = get_node("Deck")
onready var num = $DeckBack/DeckSize/Number
onready var viewer = get_node("/root/Playspace/Viewer")
const CardViewer = preload("res://scenes/CardViewer.tscn")

func _process(delta):
	var count = $Deck.get_child_count()
	num.text = str(count)
	if count > 0:
		visible = true
	else:
		visible = false

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			pass
#			var temp = CardViewer.instance()
#			viewer.add_child(temp)
#			temp.label = 'Deck'
#			for card in deck.get_children():
#				temp.grid.add_child(root.createCard(card.cardData, true, {'menu' : 'deck'}))
