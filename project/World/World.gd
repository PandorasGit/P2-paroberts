extends Node2D


signal killed


var _active_checkpoint := Vector2(50, 480)
var _kill_line := 600


onready var _player := find_node("Player")
onready var _checkpoints := find_node("CheckPoints")
onready var _music := find_node("Music")

func _ready() -> void:
	_music.play()
# warning-ignore:return_value_discarded
	connect("killed", _player, "_on_Player_killed")
# warning-ignore:return_value_discarded
	_player.connect("respawned", self, "_on_respawned")
	_connect_checkpoint_signals()


func _connect_checkpoint_signals() -> void:
	for checkpoint in _checkpoints.get_children():
		checkpoint.connect("flagged", self, "_on_Checkpoint_flagged")


func _process(_delta: float) -> void:
	if _player.position.y > _kill_line:
		_player.position = Vector2( _player.position.x, 599)
		emit_signal("killed")


func _on_respawned() -> void:
	_player.position = _active_checkpoint


func _on_Checkpoint_flagged(new_active_checkpoint: Vector2) -> void:
	_active_checkpoint = new_active_checkpoint
