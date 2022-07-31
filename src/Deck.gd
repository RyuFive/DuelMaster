extends Button

onready var root = get_node("/root/Playspace")
onready var num = $DeckBack/DeckSize/Number

func _process(delta):
	var count = $Deck.get_child_count()
	num.text = str(count)
	if count > 0:
		visible = true
	else:
		visible = false

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			pass
#			root.drawCard(1)
