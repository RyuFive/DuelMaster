extends Control

onready var root = get_node("/root/Playspace")
onready var grave = get_node("Graveyard")
onready var viewer = get_node("/root/Playspace/Viewer")
const CardViewer = preload("res://scenes/CardViewer.tscn")

func _process(delta):
	$GraveButton/GraveSize/Number.text = str(grave.get_child_count())

func _on_GraveButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			var temp = CardViewer.instance()
			viewer.add_child(temp)
			temp.label = 'Graveyard'
			for card in grave.get_children():
				temp.grid.add_child(root.createCard(card.cardData, true, {'menu' : 'grave'}))
