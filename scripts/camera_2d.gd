extends Camera2D

@export var player: CharacterBody2D
@export var follow_speed: float = 3.0
@export var x_fixed_position: float = 240.0  # Centro da tela (480/2)
@export var y_offset_from_player: float = -200.0  # NEGATIVO para player ficar na parte inferior

func _ready():
	if not player:
		player = get_node("../Player")
	
	# Posição inicial da câmera
	if player:
		global_position.x = x_fixed_position
		global_position.y = player.global_position.y + y_offset_from_player
		print("Câmera inicializada em: ", global_position)

func _physics_process(delta):
	if not player:
		return
	
	# X sempre fixo no centro
	global_position.x = x_fixed_position
	
	# Y segue o player com offset (NEGATIVO para player ficar embaixo)
	var target_y = player.global_position.y + y_offset_from_player
	global_position.y = lerp(global_position.y, target_y, follow_speed * delta)
