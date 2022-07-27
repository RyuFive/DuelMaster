extends MarginContainer

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
