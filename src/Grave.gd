extends Control

onready var root = get_node("/root/Playspace")
onready var grave = get_node("Graveyard")

func _process(delta):
	$GraveButton/GraveSize/Number.text = str(grave.get_child_count())
