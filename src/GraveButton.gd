extends TextureButton

func _process(delta):
	$GraveSize/Number.text = str(get_node("../Graveyard").get_child_count())

func _gui_input(event):
	if Input.is_action_just_pressed("leftclick"):
		$'../../'.removePopup()
		pass
