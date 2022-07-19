#tool
#extends EditorScript
extends Node

# Declare member variables here. Examples:
var file_data
var current_card_counter := 0

func savecards():
	var file = File.new()
	file.open("res://data/cards.json", File.WRITE)
	file.store_line(to_json(file_data))
	file.close()
	
func loadcards():
	var file = File.new()
	if not file.file_exists("res://data/cards.json"):
			file.open("res://data/cards.json", File.READ)
			savecards()
			return
	file.open("res://data/cards.json", File.READ)
	var data = parse_json(file.get_as_text())
	file_data = data

#func _run():
func _ready():
	loadcards()
	print(current_card_counter)
#	file_data.cards[0].name
	get_node("CardName").text = file_data.cards[current_card_counter].name
#	for card in file_data.cards:
#		print(card.name)


func _on_Button_button_up():
	current_card_counter += 1
	if current_card_counter == 1152:
		current_card_counter = 0
	get_node("CardName").text = file_data.cards[current_card_counter].name
	pass # Replace with function body.


func _on_PrevButton_button_up():
	current_card_counter -= 1
	if current_card_counter == 0:
		current_card_counter = 1151
	get_node("CardName").text = file_data.cards[current_card_counter].name
	pass # Replace with function body.
