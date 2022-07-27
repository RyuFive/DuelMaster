extends Node2D

# Loading Data
onready var CardDatabase = preload("res://data/CardDatabase.gd")
const CardBase = preload("res://scenes/CardBase.tscn")
const Deck = preload("res://data/decks/sample_deck.gd")

# Preparing Board
var Deck1 = Deck.DATA.cards.duplicate(true)
var Deck2 = Deck.DATA.cards.duplicate(true)

# Math for Hand Curve
onready var CentreCardOval = Vector2(1920, 1080) * Vector2(0.5, 1.16)
onready var Hor_rad = get_viewport().size.x * 0.6
onready var Ver_rad = get_viewport().size.y * 0.4
var angle = deg2rad(90) - 0.5
var OvalAngleVector = Vector2()

func _ready():
	randomize()
	pass # Replace with function body.

func drawcard():
	var new_card = CardBase.instance()
	new_card.cardData = Deck1.pop_at(randi() % len(Deck1))
	OvalAngleVector = Vector2(Hor_rad * cos(angle), - Ver_rad * sin(angle))
	new_card.rect_position = CentreCardOval + OvalAngleVector - new_card.rect_size/2
	new_card.rect_scale = Vector2(0.64, 0.64)
	new_card.rect_rotation = (90 - rad2deg(angle))/4
	angle += 0.17
	$Cards.add_child(new_card)
	return len(Deck1)
