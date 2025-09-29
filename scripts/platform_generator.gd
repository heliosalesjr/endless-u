extends Node2D

@export var platform_scene: PackedScene
@export var player: CharacterBody2D

# A câmera mostra de X=120 até X=360 (240px centrados em X=240)
const CAMERA_CENTER_X = 240.0
const VISIBLE_WIDTH = 240.0
const PLATFORM_WIDTH = 50.0

# Plataformas posicionadas dentro da área visível
const LEFT_X = CAMERA_CENTER_X - (VISIBLE_WIDTH / 2.0) + (PLATFORM_WIDTH / 2.0)  # 170
const RIGHT_X = CAMERA_CENTER_X + (VISIBLE_WIDTH / 2.0) - (PLATFORM_WIDTH / 2.0)  # 310

var highest_platform_y = 0.0
var platforms = []

func _ready():
	if not platform_scene or not player:
		return
	
	print("Área visível: X=", CAMERA_CENTER_X - VISIBLE_WIDTH/2, " até X=", CAMERA_CENTER_X + VISIBLE_WIDTH/2)
	print("LEFT_X: ", LEFT_X, " | RIGHT_X: ", RIGHT_X)
	
	await get_tree().process_frame
	
	highest_platform_y = player.global_position.y - 50
	
	for i in range(15):
		spawn_platform()

func spawn_platform():
	var x = LEFT_X if (randi() % 2) == 0 else RIGHT_X
	var y = highest_platform_y - randf_range(80, 120)
	
	var platform = platform_scene.instantiate()
	platform.global_position = Vector2(x, y)
	
	get_parent().add_child(platform)
	platforms.append(platform)
	highest_platform_y = y

func _process(_delta):
	if not player:
		return
	
	if highest_platform_y - player.global_position.y < 800:
		spawn_platform()
	
	cleanup_platforms()

func cleanup_platforms():
	for i in range(platforms.size() - 1, -1, -1):
		var platform = platforms[i]
		if is_instance_valid(platform):
			if platform.global_position.y > player.global_position.y + 1000:
				platform.queue_free()
				platforms.remove_at(i)
