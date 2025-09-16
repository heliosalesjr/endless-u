extends EnemyBase

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var floor_detection = $FloorDetection


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	#super eh uma keyword que se refere a parent class
	super._physics_process(delta)
	
	if is_on_floor() == false:
		velocity.y += _gravity * delta
	else:
		velocity.x = speed * _facing
	
	#so we can let the physics engine move it
	move_and_slide()
	
	if is_on_floor() == true:
		if is_on_wall() == true || floor_detection.is_colliding() == false:
			flip_me()

func flip_me():
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	floor_detection.position.x = floor_detection.position.x * -1
	
	if _facing == FACING.LEFT:
		_facing = FACING.RIGHT
	else:
		_facing = FACING.LEFT
