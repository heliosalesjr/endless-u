extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D

const CAMERA_LERP_UP: float = 0.12
const CAMERA_LERP_SIDE: float = 0.08

func _ready() -> void:
	# ativa esta câmera
	if camera:
		camera.make_current()

func _process(delta: float) -> void:  
	if not is_instance_valid(player) or not is_instance_valid(camera):
		return

	# mover câmera apenas se o player subir
	if player.global_position.y < camera.global_position.y:
		camera.global_position.y = lerp(camera.global_position.y, player.global_position.y, CAMERA_LERP_UP)

	# mover câmera no eixo X suavemente
	camera.global_position.x = lerp(camera.global_position.x, player.global_position.x, CAMERA_LERP_SIDE)
