extends Node

var deck_path := "user://Decks/sample_deck.json"
var card_scene = load("res://scenes/Card.tscn")
var player1 := []
var player2 := []

func _ready():
	loadDecks()

func loadDecks():
	var file = File.new()
	file.open(deck_path, File.READ)
	var data = parse_json(file.get_as_text())
	for card in data.cards:
		for x in card.amount:
			var temp = card_scene.instance()
			temp.data = card
			player1.append(temp)
	data = parse_json(file.get_as_text())
	for card in data.cards:
		for x in card.amount:
			var temp = card_scene.instance()
			temp.data = card
			player2.append(temp)
	file.close()
