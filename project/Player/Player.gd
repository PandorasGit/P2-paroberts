extends KinematicBody2D


signal respawned


var _is_alive := true
var _has_jumped := false
var _gravity := -0.5
var _jump_velocity := 1
var _speed := 100


onready var _respawn_timer := find_node("RespawnTimer")
onready var _sprite := find_node("AnimatedSprite")
onready var _death_particles := find_node("DeathParticles")
onready var _jump_timer := find_node("JumpTimer")
onready var _walk_particles := find_node("WalkParticles")
onready var _visuals := find_node("Visuals")


func _ready() -> void:
	# warning-ignore:return_value_discarded
	_jump_timer.connect("timeout", self, "_on_JumpTimer_timeout")
	# warning-ignore:return_value_discarded
	_respawn_timer.connect("timeout", self, "_on_RespawnTimer_timeout")


func _physics_process(_delta: float) -> void:
	var velocity := _move()
	# warning-ignore:return_value_discarded
	move_and_slide(velocity * _speed, Vector2.UP)


func _move() -> Vector2:
	var velocity := Vector2.ZERO
	if _is_alive:
		velocity = _calculate_input(velocity)
	return velocity


func _calculate_input(input: Vector2) -> Vector2:
	input.x = _caluculate_x_input()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		_has_jumped = true
		_jump_timer.start()
	if _has_jumped:
		input.y = -_jump_velocity
	input.y += -_gravity
	return input


func _caluculate_x_input() -> float:
	var x_input = Input.get_axis("move_left", "move_right")
	if not is_on_floor():
		_animate_player_flying(x_input)
	else:
		_animate_player_walking(x_input)
	return x_input


func _animate_player_flying(x_input: float) -> void:
	_sprite.play("idle")
	_walk_particles.emitting = false
	_set_visuals_direction(x_input)


func _animate_player_walking(x_input: float) -> void:
	_sprite.play("idle" if x_input==0 else "walk")
	if x_input != 0:
		_emit_walk_particles(x_input)
	else:
		_walk_particles.emitting = false


func _emit_walk_particles(x_input: float) -> void:
	_walk_particles.emitting = true
	_set_visuals_direction(x_input)


func _set_visuals_direction(x_input: float) -> void:
	if x_input < 0:
		_visuals.scale.x = -1
	elif x_input > 0:
		_visuals.scale.x = 1


func _on_JumpTimer_timeout() -> void:
	_has_jumped = false


func _on_Player_killed() -> void:
	_sprite.visible = false
	_is_alive = false
	_death_particles.emitting = true
	_respawn_timer.start()
	

func _on_RespawnTimer_timeout() -> void:
	_death_particles.emitting = false
	emit_signal("respawned")
	_sprite.visible = true
	_is_alive = true
	_respawn_timer.stop()
