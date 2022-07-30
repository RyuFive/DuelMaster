extends Control

const PORT = 3000
const MAX_USERS = 1 #not including host

const CardBase = preload("res://scenes/CardBase.tscn")
onready var root = get_node("/root/Playspace")
onready var chat_display = $RoomUI/ChatDisplay
onready var chat_input = $RoomUI/ChatInput
var id

func _ready():
	get_tree().connect("connected_to_server", self, "enter_room")
	get_tree().connect("network_peer_connected", self, "user_entered")
	get_tree().connect("network_peer_disconnected", self, "user_exited")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _server_disconnected():
	chat_display.text += "Disconnected from Server\n"
	leave_room()
	get_tree().quit()

func user_entered(p2id):
	chat_display.text += str(p2id) + " joined the room\n"
	id = get_tree().get_network_unique_id()
	root.id = id
	self.hide()
	
	root.Deck1.shuffle()
	$'../Deck1'.DeckSize = root.deck2shield(5)
	$'../Deck1'.DeckSize = root.drawCard(5)

func user_exited(p2id):
	chat_display.text += str(p2id) + " left the room\n"
	get_tree().quit()

func host_room():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(PORT, MAX_USERS)
	get_tree().set_network_peer(host)
	enter_room()
	chat_display.text = "Room Created\n"

func join_room():
	var ip = $SetUp/IpEnter.text
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, PORT)
	get_tree().set_network_peer(host)

func enter_room():
	chat_display.text = "Successfully joined room\n"
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

#func send_message():
#	var msg = chat_input.text
#	chat_input.text = ""
#	var id = get_tree().get_network_unique_id()
#	rpc("receive_message", id, msg)
#
#sync func receive_message(id, msg):
#	chat_display.text += str(id) + ": " + msg + "\n"

func updateP2(command, cardData):
	rpc(command, id, cardData)

sync func drawCard(p2id, cardData):
	if p2id != id:
		root.p2state['hand'] += 1
		var new_card = CardBase.instance()
		get_node("/root/Playspace/Hand2/Cards").add_child(new_card)

sync func handMil(p2id, cardData):
	if p2id != id:
		root.p2state['hand'] -= 1
		get_node("/root/Playspace/Hand2/Cards").remove_child(get_node("/root/Playspace/Hand2/Cards").get_child(0))

sync func graveCard(p2id, cardData):
	if p2id != id:
		var new_card = CardBase.instance()
		new_card.cardData = cardData
		new_card.visible = false
		get_node("/root/Playspace/Grave2/Graveyard").add_child(new_card)
		
sync func deckMil(p2id, cardData):
	if p2id != id:
		root.p2state['deck'] -= 1
		$'../Deck2/DeckBack/DeckSize/Number'.text = str(root.p2state['deck'])
		if root.p2state.deck == 0:
			$'../Deck2'.hide()

sync func addMana(p2id, cardData):
	if p2id != id:
		var new_card = CardBase.instance()
		new_card.cardData = cardData
		new_card.visible = false
		get_node("/root/Playspace/Mana2/Mana").add_child(new_card)
