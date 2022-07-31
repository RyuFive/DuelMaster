extends Control

onready var grid = $Panel/Grid

func _on_TouchCapture_gui_input(event):
	self.queue_free()
