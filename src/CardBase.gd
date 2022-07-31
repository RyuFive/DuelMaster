extends MarginContainer

onready var root = get_node("/root/Playspace")
onready var handPopup = get_node("/root/Playspace/Hand1/Popup")
onready var monsterPopup = get_node("/root/Playspace/Monster1/Popup")
const Popup = preload("res://scenes/Popupv2.tscn")
const CardViewer = preload("res://scenes/CardViewer.tscn")

var cardName
var cardData

func _ready():
	if cardData:
		cardName = cardData.name
	if cardData.has('flipped') and cardData['flipped']:
		$CardImg.texture = load(str("res://assets/card/Duel_Masters_cardback.png"))
	else:
		$CardImg.texture = load(str("res://assets/img/" + cardName.replace(' ', '').replace(',', '').to_lower() + ".jpg"))
	$CardImg.scale *= rect_size/$CardImg.texture.get_size()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if !root.turn:
				return
			var source = str(get_node('../../'))
			
			var temp = Popup.instance()
			temp.card = self
			
			if 'Hand' in source:
				handPopup.add_child(temp)
			elif 'Monster' in source:
				monsterPopup.add_child(temp)
