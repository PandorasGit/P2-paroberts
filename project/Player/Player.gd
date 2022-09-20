extends KinematicBody2D


func _process(_delta: float) -> void:
	var input := Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	if input.x < 0:
		$AnimatedSprite.scale.x = -1
	elif input.x > 0:
		$AnimatedSprite.scale.x = 1
# warning-ignore:return_value_discarded
	move_and_slide(input * 100, Vector2.UP)
	_apply_gravity()

func _apply_gravity() -> void:
	if not is_on_floor():
# warning-ignore:return_value_discarded
		move_and_slide(Vector2(0, 100), Vector2.UP)
