extends Control

onready var root = get_node("/root/Playspace")
onready var mana = get_node("Mana")

func _process(delta):
	$ManaButton/ManaSize/Number.text = str(mana.get_child_count())

func _gui_input(event):
	if Input.is_action_just_pressed("leftclick"):
		root.removePopup()
		pass
