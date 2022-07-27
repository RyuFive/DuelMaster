extends TextureButton

var DeckSize = 40

func _ready():
	$DeckSize/Number.text = str(DeckSize)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if DeckSize > 0:
				DeckSize = $'../../'.drawcard()
				$'../../'.removePopup()
				$DeckSize/Number.text = str(DeckSize)
				if DeckSize == 0:
					disabled = true
