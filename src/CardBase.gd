extends MarginContainer

onready var root = get_node("/root/Playspace")
onready var hand = get_node("/root/Playspace/Hand1/Popup")
onready var monster = get_node("/root/Playspace/Monster1/Popup")
const Popup = preload("res://scenes/Popup.tscn")

var cardName = ""
var cardData = ""
var flipped = false

func _ready():
	if cardData:
		cardName = cardData.name
	
	if cardName != "" and !flipped:
		$CardImg.texture = load(str("res://assets/img/" + cardName.replace(' ', '').replace(',', '').to_lower() + ".jpg"))
	else:
		$CardImg.texture = load(str("res://assets/card/Duel_Masters_cardback.png"))
	$CardImg.scale *= rect_size/$CardImg.texture.get_size()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			root.removePopup()
			if !cardData:
				return
			var source = str(get_node('../../'))
			
			var temp = Popup.instance()
			temp.card = self
			
			if 'Hand' in source:
				hand.add_child(temp)
			elif 'Monster' in source:
				monster.add_child(temp)
				
			temp.rect_position = get_global_mouse_position()
