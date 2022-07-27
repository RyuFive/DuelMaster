extends MarginContainer

const Popup = preload("res://scenes/Popup.tscn")

var cardName = ""
var cardData = ""

func _ready():
	if cardData:
		cardName = cardData.name
	if cardName != "":
		$CardImg.texture = load(str("res://assets/img/" + cardName.replace(' ', '').replace(',', '').to_lower() + ".jpg"))
	else:
		$CardImg.texture = load(str("res://assets/card/Duel_Masters_cardback.png"))
	$CardImg.scale *= rect_size/$CardImg.texture.get_size()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var parentNode = get_node("../../Popup")
			if len(parentNode.get_children()):
				parentNode.remove_child(parentNode.get_child(0))
			var temp = Popup.instance()
			temp.card = self
			parentNode.add_child(temp)
			parentNode.get_child(0).rect_position = get_global_mouse_position()
