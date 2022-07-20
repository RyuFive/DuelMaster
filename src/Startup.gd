extends Node

const SAVE_FILE = "user://save_file.save"

var game_data := {}

func savecards():
	var file = File.new()
	file.open(SAVE_FILE, File.WRITE)
	file.store_line(to_json(game_data))
	file.close()
	
func loadcards():
	var file = File.new()
	if not file.file_exists(SAVE_FILE):
			file.open("res://data/cards.json", File.READ)
			game_data = parse_json(file.get_as_text())
			savecards()
			return
	file.open(SAVE_FILE, File.READ)
	game_data = parse_json(file.get_as_text())
	file.close()

func _ready():
	loadcards()
	
