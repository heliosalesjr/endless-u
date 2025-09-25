extends Node2D

@export var platform_scene: PackedScene  # Arraste o Tile.tscn aqui
@export var player: CharacterBody2D  # Arraste o player aqui

var screen_width = 480.0
var screen_height = 852.0
var platform_width = 100.0
var generated_platforms = []

# Debug tracking
var debug_label: Label
var platform_positions = []

func _ready():
	print("=== SISTEMA DE DEBUG COMPLETO ===")
	
	# Cria label de debug na tela
	create_debug_label()
	
	if not platform_scene:
		print("ERRO: Arraste o Tile.tscn no inspector!")
		return
		
	if not player:
		print("ERRO: Player não encontrado! Tentando encontrar...")
		player = find_child("Player", true, false)
		if not player:
			player = get_node_or_null("../Player")
		if not player:
			player = get_parent().get_node_or_null("Player")
	
	if not player:
		print("ERRO CRÍTICO: Player não encontrado!")
		return
	
	await get_tree().process_frame
	create_tracked_platforms()

func create_debug_label():
	debug_label = Label.new()
	debug_label.position = Vector2(10, 10)
	debug_label.size = Vector2(400, 200)
	debug_label.modulate = Color.YELLOW
	debug_label.z_index = 1000
	get_parent().add_child(debug_label)

func create_tracked_platforms():
	print("=== CRIANDO PLATAFORMAS COM TRACKING ===")
	
	clear_all_platforms()
	platform_positions.clear()
	
	var player_pos = player.global_position
	print("Player inicial em: ", player_pos)
	
	# Cria 5 plataformas em posições fixas e previsíveis
	var test_positions = [
		Vector2(player_pos.x, player_pos.y + 100),      # Abaixo
		Vector2(240, player_pos.y - 100),               # Acima, centro
		Vector2(100, player_pos.y - 200),               # Mais acima, esquerda
		Vector2(380, player_pos.y - 300),               # Mais acima, direita
		Vector2(240, player_pos.y - 400)                # Muito acima, centro
	]
	
	var colors = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.MAGENTA]
	
	for i in range(test_positions.size()):
		var pos = test_positions[i]
		var color = colors[i]
		
		create_tracked_platform(pos, color, "TEST_" + str(i))
		platform_positions.append(pos)
		
		print("Plataforma ", i, " criada em: ", pos, " cor: ", color)
	
	print("Total plataformas: ", generated_platforms.size())
	print("Posições registradas: ", platform_positions.size())

func create_tracked_platform(pos: Vector2, color: Color, name_suffix: String):
	var platform = platform_scene.instantiate()
	platform.global_position = pos
	platform.modulate = color
	platform.name = "Platform_" + name_suffix
	platform.z_index = 50
	
	# Força o sprite a ser visível e colorido
	var sprite = platform.get_node_or_null("Sprite2D")
	if sprite:
		sprite.modulate = color
		sprite.visible = true
		sprite.scale = Vector2(1.5, 1.5)  # Um pouco maior para destacar
	
	get_parent().add_child(platform)
	generated_platforms.append(platform)

func _process(delta):
	if not player or not debug_label:
		return
	
	# Atualiza informações de debug na tela
	var player_pos = player.global_position
	var camera_pos = Vector2.ZERO
	
	var camera = get_viewport().get_camera_2d()
	if camera:
		camera_pos = camera.global_position
	
	var debug_text = "=== DEBUG TRACKING ===\n"
	debug_text += "Player: " + str(player_pos) + "\n"
	debug_text += "Camera: " + str(camera_pos) + "\n"
	debug_text += "Plataformas criadas: " + str(generated_platforms.size()) + "\n"
	debug_text += "Plataformas válidas: " + str(count_valid_platforms()) + "\n\n"
	
	debug_text += "Distâncias do player às plataformas:\n"
	for i in range(min(platform_positions.size(), 5)):
		var distance = player_pos.distance_to(platform_positions[i])
		debug_text += str(i) + ": " + str(int(distance)) + " pixels\n"
	
	debug_label.text = debug_text

func count_valid_platforms() -> int:
	var count = 0
	for platform in generated_platforms:
		if is_instance_valid(platform):
			count += 1
	return count

func clear_all_platforms():
	for platform in generated_platforms:
		if is_instance_valid(platform):
			platform.queue_free()
	generated_platforms.clear()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("=== RECRIANDO PLATAFORMAS ===")
		clear_all_platforms()
		await get_tree().process_frame
		create_tracked_platforms()
