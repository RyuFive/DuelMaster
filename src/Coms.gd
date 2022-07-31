extends Control

const CardBase = preload("res://scenes/CardBase.tscn")
onready var root = get_node("/root/Playspace")
onready var deck = get_node("/root/Playspace/Deck1/Deck")
onready var shield = get_node("/root/Playspace/Shield1/Shield")
onready var mana = get_node("/root/Playspace/Mana1/Mana")
onready var grave = get_node("/root/Playspace/Grave1/Graveyard")
onready var monster = get_node("/root/Playspace/Monster1/Cards")
onready var hand = get_node("/root/Playspace/Hand1/Cards")

onready var deck2 = get_node("/root/Playspace/Deck2/Deck")
onready var shield2 = get_node("/root/Playspace/Shield2/Shield")
onready var mana2 = get_node("/root/Playspace/Mana2/Mana")
onready var grave2 = get_node("/root/Playspace/Grave2/Graveyard")
onready var monster2 = get_node("/root/Playspace/Monster2/Cards")
onready var hand2 = get_node("/root/Playspace/Hand2/Cards")

onready var chat_display = $RoomUI/ChatDisplay
onready var chat_input = $RoomUI/ChatInput

const PORT = 3000
const MAX_USERS = 1 #not including host
var peer
var id
var players_done = []

func _ready():
	get_tree().connect("connected_to_server", self, "enter_room")
	get_tree().connect("network_peer_connected", self, "user_entered")
	get_tree().connect("network_peer_disconnected", self, "user_exited")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _server_disconnected():
	leave_room()
	get_tree().quit()

func user_entered(p2id):
	root.peer = p2id
	peer = p2id
	id = get_tree().get_network_unique_id()
	self.hide()
	rpc_id(peer, 'preConfigureGame')

func user_exited(p2id):
	get_tree().quit()

func host_room():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(PORT, MAX_USERS)
	get_tree().set_network_peer(host)
	enter_room()

func join_room():
	var ip = $SetUp/IpEnter.text
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, PORT)
	get_tree().set_network_peer(host)

func enter_room():
	chat_display.text = "Successfully joined room\nWaiting for connection..."
	$SetUp/LeaveButton.show()
	$SetUp/JoinButton.hide()
	$SetUp/HostButton.hide()
	$SetUp/IpEnter.hide()

func leave_room():
	get_tree().set_network_peer(null)
	chat_display.text += "Left Room\n"
	$SetUp/LeaveButton.hide()
	$SetUp/JoinButton.show()
	$SetUp/HostButton.show()
	$SetUp/IpEnter.show()

remote func preConfigureGame():
	randomize()
	if id == 1:
		root.turn = true
	if randi() % 2 == 0:
		rpc("changeTurn")
	var tempDeck = root.Deck.DATA.cards.duplicate(true)
	tempDeck.shuffle()
	for cardData in tempDeck:
		deck.add_child(root.createCard(cardData, false, 
		{'id': randi(), 'tapped':false}
		))
	rpc_id(peer, 'sendDeck', tempDeck)
	get_tree().set_pause(true)
	rpc_id(peer, "donePreconfiguring")
	rpc_id(id, "donePreconfiguring")

sync func donePreconfiguring():
	var who = get_tree().get_rpc_sender_id()
	assert(not who in players_done) # Was not added yet

	players_done.append(who)

	if players_done.size() == 2:
		rpc("postConfigureGame")

remote func postConfigureGame():
	get_tree().set_pause(false)
	root.drawCard(5)
	root.deck2shield(5)

remote func sendDeck(tempDeck):
	for cardData in tempDeck:
		deck2.add_child(root.createCard(cardData))

remote func addHand(cardData):
	hand2.add_child(root.createCard(cardData, true, {'flipped': true}))

remote func handMil(cardData):
	for card in hand2.get_children():
		if card.cardData.id == cardData.id:
			card.queue_free()

remote func addGrave(cardData):
	grave2.add_child(root.createCard(cardData))

remote func deckMil():
	deck2.get_child(0).queue_free()

remote func addMana(cardData):
	mana2.add_child(root.createCard(cardData))

remote func removeMana(cardData):
	for card in mana2.get_children():
		if str(card.cardData) == str(cardData):
			card.queue_free()

remote func addShield(cardData):
	var shieldGrid = get_node("/root/Playspace/Shield2/ShieldGrid")
	var shieldTexture = TextureRect.new()
	shieldTexture.texture = load("res://assets/zone/shield.png")
	shieldGrid.add_child(shieldTexture)
	shield2.add_child(root.createCard(cardData))

remote func loseShield(cardData):
	var shieldGrid = get_node("/root/Playspace/Shield1/ShieldGrid")
	shieldGrid.get_child(0).queue_free()
	
	var card = shield.get_child(0)
	if hand.get_child_count() < 9:
		hand.add_child(root.createCard(card.cardData, true))
	else:
		grave.add_child(root.createCard(card.cardData))
	card.queue_free()

remote func addMonster(cardData):
	monster2.add_child(root.createCard(cardData, true))

remote func removeMonster(cardData):
	for card in monster2.get_children():
		if str(card.cardData) == str(cardData):
			card.queue_free()

remote func loseMonster(cardData):
	for card in monster.get_children():
		if str(card.cardData) == str(cardData):
			grave.add_child(root.createCard(cardData))
			card.queue_free()

sync func changeTurn():
	root.turn = !root.turn
	if root.turn:
		root.drawCard(1)
		for card in mana.get_children():
			card.cardData['tapped'] = false
		for card in monster.get_children():
			card.cardData['tapped'] = false
	
	
	
	
