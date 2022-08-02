extends Control

onready var root = get_node("/root/Playspace")
onready var mana = get_node("Mana")
onready var viewer = get_node("/root/Playspace/Viewer")
const CardViewer = preload("res://scenes/CardViewer.tscn")
var manaCivs = {
	'Fire': false,
	'Water': false,
	'Light': false,
	'Darkness': false,
	'Nature': false,
}

func _process(delta):
	if manaCivs['Fire']:
		$ManaButton/Grid/Fire.show()
	if manaCivs['Water']:
		$ManaButton/Grid/Water.show()
	if manaCivs['Light']:
		$ManaButton/Grid/Light.show()
	if manaCivs['Darkness']:
		$ManaButton/Grid/Darkness.show()
	if manaCivs['Nature']:
		$ManaButton/Grid/Nature.show()
	$ManaButton/ManaTotal/Number.text = str(mana.get_child_count())
	var count = 0
	for card in mana.get_children():
		if !card.cardData['tapped']:
			count += 1
	$ManaButton/ManaUntapped/Number.text = str(count)

func _on_ManaButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			var temp = CardViewer.instance()
			viewer.add_child(temp)
			temp.label = 'Mana'
			for card in mana.get_children():
				temp.grid.add_child(root.createCard(card.cardData, true, {'menu' : 'mana'}))
