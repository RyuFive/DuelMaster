extends Control

onready var grid = $Panel/Scroll/Grid
var label = ''

func _process(delta):
	$Panel/Label.text = label

func _on_BG_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			self.queue_free()
