extends Node2D


signal killed


var _active_checkpoint := Vector2(50, 480)

func _ready():
# warning-ignore:return_value_discarded
	connect("killed", $Player, "_on_Player_killed")
# warning-ignore:return_value_discarded
	$Player.connect("respawned", self, "_on_respawned")
	_connect_checkpoint_signals()


func _connect_checkpoint_signals() -> void:
	for checkpoint in $CheckPoints.get_children():
		checkpoint.connect("flagged", self, "_on_Checkpoint_flagged")

func _process(_delta: float) -> void:
	if $Player.position.y > 600:
		$Player.position = Vector2( $Player.position.x, 599)
		emit_signal("killed")


func _on_respawned() -> void:
	$Player.position = _active_checkpoint


func _on_Checkpoint_flagged(new_active_checkpoint: Vector2):
	_active_checkpoint = new_active_checkpoint
