extends Node2D

onready var card_data := {
	  "civilizations": [
		"Fire"
	  ],
	  "cost": 6,
	  "name": "Bolshack Dragon",
	  "power": "6000+",
	  "printings": [
		{
		  "set": "DM-01 Base Set",
		  "id": "69/110",
		  "rarity": "Very Rare",
		  "illustrator": "Ryoya Yuki",
		  "flavor": "The last city that offended it is now a ruin.",
		  "image": "https://static.wikia.nocookie.net/duelmasters/images/3/33/BolshackDragon.jpg/revision/latest?cb=20210211053740"
		}
	  ],
	  "subtypes": [
		"Armored Dragon"
	  ],
	  "text": "While attacking, this creature gets +1000 power for each fire card in your graveyard.\nDouble breaker (This creature breaks 2 shields.)",
	  "type": "Creature"
	}

onready var card_name := $Name
onready var card_text := $Text
onready var card_cost := $Cost
onready var card_power := $Power
onready var card_civ := $Civ

# Called when the node enters the scene tree for the first time.
func _ready():
	card_name.text = card_data.name
	card_text.text = card_data.text
	card_cost.text = str(card_data.cost)
	card_power.text = card_data.power
	card_civ.text = card_data.civilizations[0]
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
