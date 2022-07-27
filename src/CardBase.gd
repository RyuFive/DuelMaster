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
			var parentNodeHand = get_node("/root/Playspace/Cards/Popup")
			var parentNodeMonster1 = get_node("/root/Playspace/Monster1/Popup")
			parentNodeHand.remove_child(parentNodeHand.get_child(0))
			parentNodeMonster1.remove_child(parentNodeMonster1.get_child(0))
			var temp = Popup.instance()
			temp.card = self
			if str(get_node('../../')).find('Card') > -1:
				parentNodeHand.add_child(temp)
				parentNodeHand.get_child(0).rect_position = get_global_mouse_position()
			elif str(get_node('../../')).find('Monster') > -1:
				parentNodeMonster1.add_child(temp)
				parentNodeMonster1.get_child(0).rect_position = get_global_mouse_position()
