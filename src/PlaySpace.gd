extends Node2D

# Preparing Nodes
onready var CardDatabase = preload("res://data/CardDatabase.gd")
const CardBase = preload("res://scenes/CardBase.tscn")
const Deck = preload("res://data/decks/sample_deck.gd")
onready var deck = get_node("Deck1")
onready var shield = get_node("Shield1/Shield")
onready var mana = get_node("Mana1/Mana")
onready var grave = get_node("Grave1/Graveyard")
onready var monster = get_node("Monster1/Cards")
onready var hand = get_node("Hand1/Cards")
onready var coms = get_node("Coms")

# Preparing Vars
var Deck1 = Deck.DATA.cards.duplicate(true)
var id

func _ready():
	randomize()

func initialize():
	Deck1.shuffle()
	$Deck1.DeckSize = deck2shield(5)
	$Deck1.DeckSize = drawCard(5)

func drawCard(num):
	for i in num:
		var data = Deck1.pop_at(0)
		coms.rpc('deckMil', id, null)
		if hand.get_child_count() >= 9:
			grave.add_child(createCard(data, false))
			coms.rpc('addGrave', id, data)
		else:
			hand.add_child(createCard(data, true))
			coms.rpc('addHand', id, null)
	return len(Deck1)

func deck2shield(num):
	for i in num:
		var node = get_node("/root/Playspace/Shield1/ShieldGrid")
		var data = Deck1.pop_at(0)
		coms.rpc('deckMil', id, null)
		if shield.get_child_count() >= 10:
			grave.add_child(createCard(data, false))
			coms.rpc('addGrave', id, data)
		else:
			shield.add_child(createCard(data, false))
			coms.rpc('addShield', id, data)
			var shieldTexture = TextureRect.new()
			shieldTexture.texture = load("res://assets/zone/shield.png")
			node.add_child(shieldTexture)
	return len(Deck1)

func hand2mana(card):
	hand.remove_child(card)
	coms.rpc('handMil', id, null)
	card.visible = false
	mana.add_child(card)
	coms.rpc('addMana', id, null)

func hand2monster(card):
	if monster.get_child_count() < 5:
		hand.remove_child(card)
		coms.rpc('handMil', id, null)
		monster.add_child(card)
		coms.rpc('addMonster', id, card.cardData)

func hand2grave(card):
	hand.remove_child(card)
	coms.rpc('handMil', id, null)
	card.visible = false
	grave.add_child(card)
	coms.rpc('addGrave', id, card.cardData)
	
func monster2grave(card):
	monster.remove_child(card)
	coms.rpc('removeMonster', id, card.cardData)
	card.visible = false
	grave.add_child(card)
	coms.rpc('addGrave', id, card.cardData)

func shield2grave(card):
	var shield2 = get_node("Shield2/Shield")
	var grave2 = get_node("Grave2/Graveyard")
	shield2.get_child(0).queue_free()
	coms.rpc('loseShield', id, card.cardData)
	# This is creating the wrong card in opponents grave
	grave2.add_child(card)

func fight(one, two):
	var green = one.cardData.power
	var red = two.cardData.power
	if green > red:
		coms.rpc("loseMonster", id, two.cardData)
		two.queue_free()
	elif green < red:
		monster2grave(one)
	elif green == red:
		monster2grave(one)
		coms.rpc("loseMonster", id, two.cardData)
		two.queue_free()

func createCard(cardData, vis):
	var new_card = CardBase.instance()
	new_card.cardData = cardData
	new_card.visible = vis
	return(new_card)

func _on_ExitButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().quit()

func _input(event):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	if Input.is_action_pressed('k'):
		pass
	if Input.is_action_pressed('p'):
		coms.hide()
	if Input.is_action_pressed('l'):
		pass
