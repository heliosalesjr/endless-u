extends CharacterBody2D

@export var gravity = 400
@export var speed = 125
@export var jump_force = 200

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

# Offsets para ajustar posição quando vira
@export var collision_offset_right = Vector2(0, 0)
@export var collision_offset_left = Vector2(-5, 0)
@export var sprite_offset_right = Vector2(0, 0)
@export var sprite_offset_left = Vector2(-5, 0)

func _physics_process(delta):
	if is_on_floor() == false:
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
		
	if Input.is_action_just_pressed("jump"):
		jump(jump_force)
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		animated_sprite_2d.flip_h = (direction == -1)
		
		# Ajusta posições baseado na direção
		if direction == -1:  # esquerda
			collision_shape.position = collision_offset_left
			animated_sprite_2d.position = sprite_offset_left
		else:  # direita
			collision_shape.position = collision_offset_right
			animated_sprite_2d.position = sprite_offset_right
	
	velocity.x = direction * speed
	move_and_slide()
	update_animations(direction)

func jump(force):
	velocity.y = -force
	
func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")
