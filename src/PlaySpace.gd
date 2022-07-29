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

# Preparing Vars
var Deck1 = Deck.DATA.cards.duplicate(true)
var p2state = {}

func _ready():
	randomize()
	Deck1.shuffle()
	deck.DeckSize = deck2shield(5)
	deck.DeckSize = drawCard(5)
	
	#Setting up Player 2's side
	$Shield2.shield = get_node(str("/root/Playspace/Shield2/Shield"))
	$Mana2.mana = get_node(str("/root/Playspace/Mana2/Mana"))
	$Grave2.grave = get_node(str("/root/Playspace/Grave2/Graveyard"))

func drawCard(num):
	for i in num:
		var new_card = CardBase.instance()
		new_card.cardData = Deck1.pop_at(0)
		if hand.get_child_count() >= 9:
			new_card.visible = false
			grave.add_child(new_card)
		else:
			hand.add_child(new_card)
	return len(Deck1)

func deck2shield(num):
	for i in num:
		var new_card = CardBase.instance()
		new_card.cardData = Deck1.pop_at(0)
		new_card.visible = false
		if shield.get_child_count() >= 10:
			grave.add_child(new_card)
		else:
			shield.add_child(new_card)
			var shield = TextureRect.new()
			shield.texture = load("res://assets/zone/shield.png")
			get_node("/root/Playspace/Shield1/ShieldGrid").add_child(shield)
	return len(Deck1)

func hand2mana(card):
	hand.remove_child(card)
	card.visible = false
	mana.add_child(card)

func hand2monster(card):
	if monster.get_child_count() < 5:
		hand.remove_child(card)
		monster.add_child(card)

func hand2grave(card):
	hand.remove_child(card)
	card.visible = false
	grave.add_child(card)
	
func monster2grave(card):
	monster.remove_child(card)
	card.visible = false
	grave.add_child(card)

func getState():
	var data = {}
	
	data['hand'] = hand.get_child_count()
	data['deck'] = deck.DeckSize
	data['monster'] = monster
	data['shield'] = shield.get_child_count()
	data['grave'] = grave.get_child_count()
	data['mana'] = mana.get_child_count()
	
	return(data)

func receiveState():
	p2state = getState()
	
	#Shield
	for child in get_node("/root/Playspace/Shield2/Shield").get_children():
		child.free()
	for child in get_node("/root/Playspace/Shield2/ShieldGrid").get_children():
		child.free()
	for i in p2state.shield:
		var shield = TextureRect.new()
		shield.texture = load("res://assets/zone/shield.png")
		get_node("/root/Playspace/Shield2/ShieldGrid").add_child(shield)
		var card = CardBase.instance()
		card.visible = false
		get_node("/root/Playspace/Shield2/Shield").add_child(card)

	#Monster
	for child in get_node("/root/Playspace/Monster2/Cards").get_children():
		child.free()
	for card in p2state.monster.get_children():
		var new_card = CardBase.instance()
		new_card.cardData = card.cardData
		get_node("/root/Playspace/Monster2/Cards").add_child(new_card)

	#Deck
	if (p2state.deck >= 0):
		$Deck2.DeckSize = p2state.deck
		$Deck2/DeckBack/DeckSize/Number.text = str(p2state.deck)

	#Grave
	for child in get_node("/root/Playspace/Grave2/Graveyard").get_children():
		child.free()
	for i in p2state.grave:
		var card = CardBase.instance()
		card.visible = false
		get_node("/root/Playspace/Grave2/Graveyard").add_child(card)

	#Mana
	for child in get_node("/root/Playspace/Mana2/Mana").get_children():
		child.free()
	for i in p2state.mana:
		var card = CardBase.instance()
		card.visible = false
		get_node("/root/Playspace/Mana2/Mana").add_child(card)

	#Hand
	for child in get_node("/root/Playspace/Hand2/Cards").get_children():
		child.free()
	for i in p2state.hand:
		var card = CardBase.instance()
		get_node("/root/Playspace/Hand2/Cards").add_child(card)

func removePopup():
	for popup in $Hand1/Popup.get_children():
		popup.free()
	for popup in $Monster1/Popup.get_children():
		popup.free()

func _on_BG_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			removePopup()

func _on_ExitButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().quit()
			
func _input(event):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	if Input.is_action_pressed("copy"):
		receiveState()
	if Input.is_action_pressed('k'):
		var peer = NetworkedMultiplayerENet.new()
		peer.create_server(9999, 1)
		get_tree().network_peer = peer
		print("Room Created\n")
	if Input.is_action_pressed('l'):
		var peer = NetworkedMultiplayerENet.new()
		peer.create_client('localhost', 9999)
		get_tree().network_peer = peer
		print("Successfully Joined Room\n")
