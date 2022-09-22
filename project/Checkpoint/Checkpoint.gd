extends Area2D

signal flagged(new_position)


var _is_lit := false


onready var _particles := find_node("ActivatedParticles")


func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(_body: Area2D)-> void:
	if not _is_lit:
		_particles.emitting = true
		_is_lit = true
		emit_signal("flagged", position)
