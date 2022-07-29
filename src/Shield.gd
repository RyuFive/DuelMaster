extends Control

onready var root = get_node("/root/Playspace")
onready var shield = get_node("Shield")

func _process(delta):
	$'ShieldSize/Number'.text = str(shield.get_child_count())
