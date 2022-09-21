extends KinematicBody2D


var _has_jumped := false
var _gravity := 0.5
var _jump_velocity = -1
var _walk_velocity = 1

func _ready():
# warning-ignore:return_value_discarded
	$JumpTimer.connect("timeout", self, "_on_JumpTimer_timeout")


func _process(_delta: float) -> void:
	var input := _calculate_velocity()
# warning-ignore:return_value_discarded
	move_and_slide(input * 100, Vector2.UP)


func _calculate_velocity() -> Vector2:
	var velocity := Vector2.ZERO
	velocity.x = Input.get_axis("move_left", "move_right")
	if velocity.x < 0:
		$AnimatedSprite.scale.x = -_walk_velocity
	elif velocity.x > 0:
		$AnimatedSprite.scale.x = _walk_velocity
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		_has_jumped = true
		$JumpTimer.start()
	if _has_jumped:
		velocity.y = _jump_velocity
	velocity.y += _gravity
	return velocity


func _on_JumpTimer_timeout() -> void:
	_has_jumped = false
