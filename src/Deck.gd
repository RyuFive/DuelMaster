extends Button

onready var DeckSize = 40
onready var root = get_node("/root/Playspace")
onready var num = $DeckBack/DeckSize/Number

func _process(delta):
	if DeckSize > 0:
		num.text = str(DeckSize)
	elif DeckSize == 0:
		visible = false

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			DeckSize = root.drawCard(1)
