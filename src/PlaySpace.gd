extends Node2D

# Loading Data
onready var CardDatabase = preload("res://data/CardDatabase.gd")
const CardBase = preload("res://scenes/CardBase.tscn")
const Deck = preload("res://data/decks/sample_deck.gd")

# Preparing Board
var Deck1 = Deck.DATA.cards.duplicate(true)
var Deck2 = Deck.DATA.cards.duplicate(true)

func _ready():
	randomize()
	pass # Replace with function body.

func drawcard():
	var new_card = CardBase.instance()
	new_card.cardData = Deck1.pop_at(randi() % len(Deck1))
	if $Cards/HBox.get_child_count() >= 9:
		new_card.visible = false
		$Grave1/Graveyard.add_child(new_card)
	else:
		$Cards/HBox.add_child(new_card)
	return len(Deck1)

func hand2mana(card):
	$Cards/HBox.remove_child(card)
	card.visible = false
	$Mana1/Mana.add_child(card)

func hand2monster(card):
	if $Monster1/HBox.get_child_count() < 5:
		$Cards/HBox.remove_child(card)
		$Monster1/HBox.add_child(card)

func hand2grave(card):
	$Cards/HBox.remove_child(card)
	card.visible = false
	$Grave1/Graveyard.add_child(card)

func removePopup():
	if $Cards/Popup.get_children():
		$Cards/Popup.remove_child($Cards/Popup.get_child(0))
	if $Monster1/Popup.get_children():
		$Monster1/Popup.remove_child($Monster1/Popup.get_child(0))

func _on_Button_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			removePopup()


func _on_ExitButton_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().quit()
