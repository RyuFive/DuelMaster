extends Control

const CardBase = preload("res://scenes/CardBase.tscn")
onready var root = get_node("/root/Playspace")
onready var chat_display = $RoomUI/ChatDisplay
onready var chat_input = $RoomUI/ChatInput

const PORT = 3000
const MAX_USERS = 1 #not including host
var id

func _ready():
	get_tree().connect("connected_to_server", self, "enter_room")
	get_tree().connect("network_peer_connected", self, "user_entered")
	get_tree().connect("network_peer_disconnected", self, "user_exited")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _server_disconnected():
	leave_room()
	get_tree().quit()

func user_entered(p2id):
	id = get_tree().get_network_unique_id()
	root.id = id
	self.hide()
	root.initialize()

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

sync func addHand(p2id, cardData):
	var node = get_node("/root/Playspace/Hand2/Cards")
	if p2id != id:
		node.add_child(root.createCard(null, true))

sync func handMil(p2id, cardData):
	var node = get_node("/root/Playspace/Hand2/Cards")
	if p2id != id:
		node.get_child(0).queue_free()

sync func addGrave(p2id, cardData):
	var node = get_node("/root/Playspace/Grave2/Graveyard")
	if p2id != id:
		node.add_child(root.createCard(null, false))
		
sync func deckMil(p2id, cardData):
	var node = $'/root/Playspace/Deck2/'
	if p2id != id:
		node.DeckSize -= 1

sync func addMana(p2id, cardData):
	var node = get_node("/root/Playspace/Mana2/Mana")
	if p2id != id:
		node.add_child(root.createCard(null, false))

sync func removeMana(p2id, cardData):
	var node = get_node("/root/Playspace/Mana2/Mana")
	if p2id != id:
		for card in node.get_children():
			if card.cardData.name == cardData.name:
				node.remove_child(card)
				break

sync func addShield(p2id, cardData):
	var node = get_node("/root/Playspace/Shield2/Shield")
	var node2 = get_node("/root/Playspace/Shield2/ShieldGrid")
	if p2id != id:
		node.add_child(root.createCard(cardData, false))
		var shieldTexture = TextureRect.new()
		shieldTexture.texture = load("res://assets/zone/shield.png")
		node2.add_child(shieldTexture)

sync func loseShield(p2id, cardData):
	var node = get_node("/root/Playspace/Shield1/Shield")
	var node2 = get_node("/root/Playspace/Shield1/ShieldGrid")
	var node3 = get_node("/root/Playspace/Hand1/Cards")
	var node4 = get_node("/root/Playspace/Grave1/Graveyard")
	var node5 = get_node("/root/Playspace/Grave2/Graveyard")
	if p2id != id:
		node2.get_child(0).queue_free()
		var brokenShield = node.get_child(0)
		node.remove_child(brokenShield)
		if node3.get_child_count() < 9:
			node3.add_child(brokenShield)
			brokenShield.visible = true
		else:
			node4.add_child(brokenShield)

sync func addMonster(p2id, cardData):
	var node = get_node("/root/Playspace/Monster2/Cards")
	if p2id != id:
		node.add_child(root.createCard(cardData, true))

sync func removeMonster(p2id, cardData):
	var node = get_node("/root/Playspace/Monster2/Cards")
	if p2id != id:
		for card in node.get_children():
			if card.cardData.name == cardData.name:
				node.remove_child(card)
				break

sync func loseMonster(p2id, cardData):
	var node = get_node("/root/Playspace/Monster1/Cards")
	if p2id != id:
		for card in node.get_children():
			if card.cardData.name == cardData.name:
				node.remove_child(card)
				break
