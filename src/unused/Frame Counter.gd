extends Node2D

func _ready():
	$Label.text = "2"

func _process(delta):
	$Label.text = str(Engine.get_frames_drawn())
