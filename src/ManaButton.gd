extends TextureButton

func _process(delta):
	$ManaSize/Number.text = str(get_node("../Mana").get_child_count())

func _gui_input(event):
	if Input.is_action_just_pressed("leftclick"):
		$'../../'.removePopup()
		pass
