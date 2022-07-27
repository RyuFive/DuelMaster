extends MarginContainer

onready var card_name := $Name
onready var card_text := $Text
onready var card_cost := $Cost
onready var card_power := $Power
onready var card_civ := $Civ

var data

func _ready():
	details(data)
	pass
	
func details(card_data):
	card_name.text = card_data.name
	card_text.text = card_data.text if (card_data.has("text")) else ""
	card_cost.text = str(card_data.cost)
	card_power.text = card_data.power if (card_data.has("power")) else ""
	card_civ.text = card_data.civilizations[0]
