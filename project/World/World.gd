extends Node2D


signal killed


var _active_checkpoint := Vector2(50, 480)

func _ready():
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
	connect("killed", $Player, "_on_Player_killed")
# warning-ignore:return_value_discarded
	$Player.connect("respawned", self, "_on_respawned")


func _process(_delta: float) -> void:
	if $Player.position.y > 600:
		$Player.position = Vector2( $Player.position.x, 599)
		emit_signal("killed")


func _on_respawned() -> void:
	$Player.position = _active_checkpoint
