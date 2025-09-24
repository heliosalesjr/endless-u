extends Camera2D

@export var player: CharacterBody2D  # Arraste o player aqui no inspector
@export var camera_x_position: float = 240.0  # Centro horizontal da tela (480/2)
@export var player_y_offset: float = 200.0  # Distância do player até a parte inferior da tela
@export var smooth_speed: float = 5.0  # Velocidade de suavização da câmera

func _ready():
	# Se o player não foi definido no inspector, tenta encontrar automaticamente
	if player == null:
		player = get_node("../Player")  # Ajuste o caminho conforme necessário
	
	# Define a posição inicial da câmera
	if player:
		position.x = camera_x_position
		position.y = player.global_position.y - player_y_offset

func _physics_process(delta):
	if player == null:
		return
	
	# Mantém X fixo no centro da tela
	position.x = camera_x_position
	
	# Calcula a posição Y desejada (sempre acompanha o player)
	var target_y = player.global_position.y - player_y_offset
	
	# Suaviza o movimento vertical
	position.y = lerp(position.y, target_y, smooth_speed * delta)
