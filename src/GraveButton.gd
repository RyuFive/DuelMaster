extends TextureButton

onready var root = get_node("/root/Playspace")
onready var grave = get_node("/root/Playspace/Grave1/Graveyard")

func _process(delta):
	$GraveSize/Number.text = str(grave.get_child_count())

func _gui_input(event):
	if Input.is_action_just_pressed("leftclick"):
		root.removePopup()
		pass
