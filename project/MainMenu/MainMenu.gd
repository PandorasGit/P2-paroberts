extends Control


var world = preload("res://World/World.tscn")


onready var _startbutton := find_node("StartButton")


func _ready() -> void:
# warning-ignore:return_value_discarded
	_startbutton.connect("pressed", self, "_on_startbutton_pressed")


func _on_startbutton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(world)
