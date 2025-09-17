extends Node2D

@onready var start_position = $StartPosition
@onready var player = $Player

func _ready():
	pass

func _process(delta):
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
