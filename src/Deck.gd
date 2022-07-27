extends TextureButton


var DeckSize = INF

func _ready():
	pass

func _gui_input(event):
	if Input.is_action_just_pressed("leftclick"):
		if DeckSize > 0:
			DeckSize = $'../../'.drawcard()
			if DeckSize == 0:
				disabled = true
