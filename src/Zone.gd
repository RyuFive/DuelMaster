extends Node2D

var deck_path := "user://decks/sample_deck.json"
var card_scene = load("res://scenes/Card.tscn")

onready var SDeck1 := $Deck1
onready var SDeck2 := $Deck2

var Deck1 := []
var Deck2 := []
var Hand1 := []
var Hand2 := []
var Monster1 := []
var Monster2 := []
var Grave1 := []
var Grave2 := []
var Mana1 := []
var Mana2 := []


func _ready():
	loadDecks()
	
	
func _process(delta):
	checkDeckCount()
	showHands()
	
func showHands():
	pass
	
func checkDeckCount():
	if len(Deck1) > 0:
		SDeck1.visible = true
		SDeck1.hint_tooltip = str(len(Deck1), " cards left")
	else:
		SDeck1.visible = false
	if len(Deck2) > 0:
		SDeck2.visible = true
		SDeck2.hint_tooltip = str(len(Deck2), " cards left")
	else:
		SDeck2.visible = false

func loadDecks():
	var file = File.new()
	file.open(deck_path, File.READ)
	var data = parse_json(file.get_as_text())
	for card in data.cards:
		for x in card.amount:
			var temp = card_scene.instance()
			temp.data = card
			Deck1.append(temp)
		Deck1.shuffle()
	data = parse_json(file.get_as_text())
	for card in data.cards:
		for x in card.amount:
			var temp = card_scene.instance()
			temp.data = card
			Deck2.append(temp)
		Deck2.shuffle()
	file.close()

func _on_Deck1_pressed():
	var temp = Deck1.pop_front()
	Hand1.append(temp)
	$HBox.add_child(temp)
	


func _on_Deck2_pressed():
	Hand2.append(Deck2.pop_front())
