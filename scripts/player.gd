extends CharacterBody2D

@export var gravity: float = 1600.0
@export var jump_impulse: float = 420.0
@export var max_horizontal_speed: float = 160.0
@export var horizontal_accel: float = 0.15

var health: int = 3
var highest_y: float = 1e9
var death_buffer: float = 420.0

func _ready() -> void:
	highest_y = global_position.y

func _physics_process(delta: float) -> void:
	# gravidade
	velocity.y += gravity * delta

	# input horizontal (left/right)
	var h: int = 0
	if Input.is_action_pressed("left"):
		h -= 1
	if Input.is_action_pressed("right"):
		h += 1
	velocity.x = lerp(velocity.x, h * max_horizontal_speed, horizontal_accel)

	# impulso para cima sempre que aperta jump (space/click)
	if Input.is_action_just_pressed("ui_jump"):
		velocity.y = -jump_impulse

	# aplicar movimento
	move_and_slide()

	# atualizar ponto mais alto
	if global_position.y < highest_y:
		highest_y = global_position.y

	# checar morte (se cair abaixo da câmera)
	if global_position.y > highest_y + death_buffer:
		_die()

func _die() -> void:
	queue_free()
