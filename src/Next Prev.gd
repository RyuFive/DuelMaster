extends Node

onready var CardDatabase = preload("res://data/CardDatabase.gd")
onready var CardName = $Center/VBox/CardName

var current_card_counter := 0
var card_scene = load("res://scenes/Card.tscn")
var card = card_scene.instance()

func _ready():
	add_child(card)
	update()

func _on_Button_button_up():
	current_card_counter += 1
	if current_card_counter == 1152:
		current_card_counter = 0
	update()

func _on_PrevButton_button_up():
	current_card_counter -= 1
	if current_card_counter == 0:
		current_card_counter = 1151
	update()

func update():
	CardName.text = CardDatabase.DATA.cards[current_card_counter].name
	card.data = CardDatabase.DATA.cards[current_card_counter]
