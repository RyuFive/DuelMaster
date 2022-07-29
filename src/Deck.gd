extends Button

var player = 1
onready var DeckSize = 40
onready var root = get_node("/root/Playspace")
onready var num = $DeckBack/DeckSize/Number

func _process(delta):
	num.text = str(DeckSize)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			root.removePopup()
			if player == 1:
				if DeckSize > 0:
					DeckSize = root.drawCard(1)
					num.text = str(DeckSize)
				elif DeckSize == 0:
					num.text = str(DeckSize)
					visible = false
