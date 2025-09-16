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
