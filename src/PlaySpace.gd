extends Control

# Preparing Nodes
onready var CardDatabase = preload("res://data/CardDatabase.gd")
const CardBase = preload("res://scenes/CardBase.tscn")
const CardViewer = preload("res://scenes/CardViewer.tscn")
const Deck = preload("res://data/decks/sample_deck.gd")
onready var deck = get_node("Deck1/Deck")
onready var shield = get_node("Shield1/Shield")
onready var mana = get_node("Mana1/Mana")
onready var grave = get_node("Grave1/Graveyard")
onready var monster = get_node("Monster1/Cards")
onready var hand = get_node("Hand1/Cards")

onready var deck2 = get_node("Deck2/Deck")
onready var shield2 = get_node("Shield2/Shield")
onready var mana2 = get_node("Mana2/Mana")
onready var grave2 = get_node("Grave2/Graveyard")
onready var monster2 = get_node("Monster2/Cards")
onready var hand2 = get_node("Hand2/Cards")

onready var coms = get_node("Coms")

# Preparing Vars
var Deck1
var Deck2
var peer
var manaPerTurn = false
var turn = true
var turnCount = 1
var attackStarted = false

func drawCard(num):
	yield(get_tree().create_timer(0.001), "timeout")
	for i in num:
		var card = deck.get_child(i)
		if hand.get_child_count() >= 9:
			grave.add_child(createCard(card.cardData))
			coms.rpc_id( peer, 'addGrave', card.cardData)
		else:
			hand.add_child(createCard(card.cardData, true))
			coms.rpc_id(peer, 'addHand', card.cardData)
		card.queue_free()
	coms.rpc_id(peer, 'deckMil', num)

func deck2shield(num):
	yield(get_tree().create_timer(0.001), "timeout")
	for i in num:
		var shieldGrid = get_node("/root/Playspace/Shield1/ShieldGrid")
		var card = deck.get_child(i)
		if shield.get_child_count() >= 10:
			grave.add_child(createCard(card.cardData))
			coms.rpc_id(peer, 'addGrave', card.cardData)
		else:
			shield.add_child(createCard(card.cardData))
			coms.rpc_id(peer, 'addShield', card.cardData)
			var shieldTexture = TextureRect.new()
			shieldTexture.texture = load("res://assets/zone/shield.png")
			shieldGrid.add_child(shieldTexture)
		card.queue_free()
	coms.rpc_id(peer, 'deckMil', num)

func hand2mana(card):
	manaPerTurn = true
	coms.rpc_id(peer, 'handMil', card.cardData)
	mana.add_child(createCard(card.cardData))
	for civ in card.cardData.civilizations:
		mana.get_parent().manaCivs[civ] = true
	coms.rpc_id(peer, 'addMana', card.cardData)
	card.queue_free()

func hand2monster(card):
	coms.rpc_id(peer, 'addMonster', card.cardData)
	monster.add_child(createCard(card.cardData, true, {'sickness' : true}))
	coms.rpc_id(peer, 'handMil', card.cardData)
	card.queue_free()
	if card.cardData.name == 'Aqua Hulcus':
		drawCard(1)

func hand2grave(card):
	grave.add_child(createCard(card.cardData))
	coms.rpc_id(peer, 'addGrave', card.cardData)
	coms.rpc_id(peer, 'handMil', card.cardData)
	card.queue_free()
	
func monster2grave(card):
	if card.cardData.name == 'Aqua Knight':
		hand.add_child(createCard(card.cardData, true))
		coms.rpc_id(peer, 'addHand', card.cardData)
	else:
		grave.add_child(createCard(card.cardData))
		coms.rpc_id(peer, 'addGrave', card.cardData)
	coms.rpc_id(peer, 'removeMonster', card.cardData)
	card.queue_free()

func shieldbreak(card):
	var tempShield = shield2.get_child(0)
	var shieldGrid2 = get_node("/root/Playspace/Shield2/ShieldGrid")
	shieldGrid2.remove_child(shieldGrid2.get_child(0))
	coms.rpc_id(peer, 'loseShield', tempShield.cardData)
	if hand2.get_child_count() < 9:
		hand2.add_child(createCard(tempShield.cardData, true, {'flipped': true}))
	else:
		grave2.add_child(createCard(tempShield.cardData))
	tempShield.queue_free()
	coms.rpc_id(peer, 'tapMonster', card.cardData)

func tapmana(card):
	var counter = 0
	var tapCount = 0
	while tapCount != int(card.cardData.cost):
		var tempCard = mana.get_child(counter)
		if tempCard.cardData['tapped']:
			counter += 1
			continue
		coms.rpc_id(peer, 'tapMana', tempCard.cardData)
		tempCard.cardData['tapped'] = true
		counter += 1
		tapCount += 1

func evolve(evolution, card):
	# remember to factor in spiral gate
	pass

func fight(one, two):
	var green = one.cardData.power
	var red = two.cardData.power
	if green > red:
		coms.rpc_id(peer, 'loseMonster', two.cardData)
		grave2.add_child(createCard(two.cardData))
		coms.rpc_id(peer, 'tapMonster', one.cardData)
		two.queue_free()
	elif green < red:
		monster2grave(one)
		coms.rpc_id(peer, 'removeMonster', one.cardData)
	elif green == red:
		monster2grave(one)
		coms.rpc_id(peer, 'loseMonster', two.cardData)
		coms.rpc_id(peer, 'removeMonster', one.cardData)
		grave2.add_child(createCard(two.cardData))
		two.queue_free()

func createCard(cardData : Dictionary, vis = false, extra = {}):
	var new_card = CardBase.instance()
	new_card.cardData = merge_dict(cardData, extra)
	new_card.visible = vis
	return(new_card)

func endTurn():
	for card in mana2.get_children():
		card.cardData['tapped'] = false
	for card in monster2.get_children():
		card.cardData['sickness'] = false
	coms.rpc("changeTurn")

func _on_ExitButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().quit()

func _on_EndTurnButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if turn:
				endTurn()

func _input(event):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	if Input.is_action_pressed('k'):
		pass
	if Input.is_action_pressed('p'):
		coms.rpc("changeTurn")
	if Input.is_action_pressed('l'):
		pass

func merge_array(array_1: Array, array_2: Array, deep_merge: bool = false) -> Array:
	var new_array = array_1.duplicate(true)
	var compare_array = new_array
	var item_exists

	if deep_merge:
		compare_array = []
		for item in new_array:
			if item is Dictionary or item is Array:
				compare_array.append(JSON.print(item))
			else:
				compare_array.append(item)

	for item in array_2:
		item_exists = item
		if item is Dictionary or item is Array:
			item = item.duplicate(true)
			if deep_merge:
				item_exists = JSON.print(item)

		if not item_exists in compare_array:
			new_array.append(item)
	return new_array

func merge_dict(dict_1: Dictionary, dict_2: Dictionary, deep_merge: bool = false) -> Dictionary:
	var new_dict = dict_1.duplicate(true)
	for key in dict_2:
		if key in new_dict:
			if deep_merge and dict_1[key] is Dictionary and dict_2[key] is Dictionary:
				new_dict[key] = merge_dict(dict_1[key], dict_2[key])
			elif deep_merge and dict_1[key] is Array and dict_2[key] is Array:
				new_dict[key] = merge_array(dict_1[key], dict_2[key])
			else:
				new_dict[key] = dict_2[key]
		else:
			new_dict[key] = dict_2[key]
	return new_dict
