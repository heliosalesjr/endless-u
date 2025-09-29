extends Node2D

@export var platform_scene: PackedScene
@export var player: CharacterBody2D

const SCREEN_WIDTH = 480.0
const PLATFORM_WIDTH = 100.0
const LEFT_X = 50.0
const RIGHT_X = 430.0

var platforms_created = 0
var platform_positions = []

func _ready():
	if not platform_scene or not player:
		print("FALTA platform_scene ou player!")
		return
	
	print("=== INICIANDO CRIAÇÃO ===")
	print("Player em Y: ", player.global_position.y)
	
	var camera = get_viewport().get_camera_2d()
	if camera:
		print("Câmera em Y: ", camera.global_position.y)
	
	await get_tree().process_frame
	
	# Cria 8 plataformas ACIMA do player
	for i in range(8):
		var x = LEFT_X if i % 2 == 0 else RIGHT_X
		var y = player.global_position.y - 50 - (i * 100)
		
		create_platform_at(x, y, i)
		platform_positions.append(Vector2(x, y))
	
	print("=== FINALIZADO ===")
	print("Total: ", platforms_created)

func create_platform_at(x: float, y: float, index: int):
	var platform = platform_scene.instantiate()
	platform.global_position = Vector2(x, y)
	platform.name = "Plat_" + str(index)
	
	get_parent().add_child(platform)
	platforms_created += 1
	
	print("Plataforma ", index, " criada em Y=", y)

func _process(_delta):
	queue_redraw()

func _draw():
	# Desenha círculos onde as plataformas estão
	for pos in platform_positions:
		var local_pos = to_local(pos)
		draw_circle(local_pos, 10, Color.RED)
	
	# Info no topo (posição global na tela)
	if player:
		var camera = get_viewport().get_camera_2d()
		var cam_y = camera.global_position.y if camera else 0
		var text = "Plats: " + str(platforms_created) + " | Player Y: " + str(int(player.global_position.y)) + " | Cam Y: " + str(int(cam_y))
		draw_string(ThemeDB.fallback_font, Vector2(10, 30), text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.YELLOW)
