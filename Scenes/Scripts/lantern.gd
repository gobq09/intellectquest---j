extends Node2D

@export_enum("Down", "Up", "Left", "Right") var face

@onready var light1 = $StaticBody2D/PointLight2D
@onready var light2 = $StaticBody2D/PointLight2D2
@onready var config_file = SaveManager.load_game("config_file")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_face(face)
	load_graphics()
	SignalManager.graphics_mode.connect(load_graphics)

func _set_face(value):
		face = value
		if face == 0:
			%Sprite2D.frame = 0
		elif face == 1:
			%Sprite2D.frame = 1
		elif face == 2:
			%Sprite2D.frame = 2
			%CollisionShape2D.position.x = 8
			$StaticBody2D/LightOccluder2D.position.x = 8
		elif face == 3:
			%Sprite2D.frame = 3
			%CollisionShape2D.position.x = -8
			$StaticBody2D/LightOccluder2D.position.x = -8
		else:
			%Sprite2D.frame = 0

func load_graphics():
	config_file = SaveManager.load_game("config_file")
	var mode = config_file["Graphics_Mode"]
	if mode == "Low":
		print("received low")
		light1.visible = false
		light2.visible = false
		light1.enabled = false
		light2.enabled = false
	else:
		print("received high")
		light1.visible = true
		light2.visible = true
		light1.enabled = true
		light2.enabled = true

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$StaticBody2D.visible = true
	$StaticBody2D.process_mode = Node.PROCESS_MODE_INHERIT


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$StaticBody2D.visible = false
	$StaticBody2D.process_mode = Node.PROCESS_MODE_DISABLED
