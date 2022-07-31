extends Control

onready var root = get_node("/root/Playspace")
onready var mana = get_node("Mana")
var manaCivs = {
	'Fire': false,
	'Water': false,
	'Light': false,
	'Darkness': false,
	'Nature': false,
}

func _process(delta):
	$ManaButton/ManaSize/Number.text = str(mana.get_child_count())
