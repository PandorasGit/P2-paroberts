extends KinematicBody2D



signal respawned

var _is_alive := true
var _has_jumped := false
var _gravity := 0.5
var _jump_velocity := -1
var _walk_velocity := 1


func _ready():
# warning-ignore:return_value_discarded
	$JumpTimer.connect("timeout", self, "_on_JumpTimer_timeout")
# warning-ignore:return_value_discarded
	$RespawnTimer.connect("timeout", self, "_on_RespawnTimer_timeout")


func _process(_delta: float) -> void:
	var velocity := _move()
# warning-ignore:return_value_discarded
	move_and_slide(velocity * 100, Vector2.UP)


func _move() -> Vector2:
	var velocity := Vector2.ZERO
	if _is_alive:
		velocity = _calculate_velocity(velocity)
	return velocity


func _calculate_velocity(velocity: Vector2) -> Vector2:
	
	velocity.x = Input.get_axis("move_left", "move_right")
	if velocity.x != 0:
		$AnimatedSprite.play("walk")
		if velocity.x < 0:
			$AnimatedSprite.scale.x = -_walk_velocity
		elif velocity.x > 0:
			$AnimatedSprite.scale.x = _walk_velocity
	else:
		$AnimatedSprite.play("idle")
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		_has_jumped = true
		$JumpTimer.start()
	if _has_jumped:
		velocity.y = _jump_velocity
	velocity.y += _gravity
	return velocity


func _on_JumpTimer_timeout() -> void:
	_has_jumped = false


func _on_Player_killed() -> void:
	$AnimatedSprite.visible = false
	_is_alive = false
	$DeathParticles.emitting = true
	$RespawnTimer.start()
	

func _on_RespawnTimer_timeout() -> void:
	$DeathParticles.emitting = false
	emit_signal("respawned")
	$AnimatedSprite.visible = true
	_is_alive = true
	$RespawnTimer.stop()
