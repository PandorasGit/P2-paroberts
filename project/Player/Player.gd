extends KinematicBody2D


func _process(_delta: float) -> void:
	var input := Vector2.ZERO
	
	input.x = Input.get_axis("move_left", "move_right")
	move_and_slide(input * 100, Vector2.UP)
