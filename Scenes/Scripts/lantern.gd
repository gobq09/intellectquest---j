extends Node2D

@export_enum("Down", "Up", "Left", "Right") var face

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if face == 0:
		$StaticBody2D/Sprite2D.frame = 0
	elif face == 1:
		$StaticBody2D/Sprite2D.frame = 1
	elif face == 2:
		$StaticBody2D/Sprite2D.frame = 2
		$StaticBody2D/CollisionShape2D.position.x = 8
		$StaticBody2D/LightOccluder2D.position.x = 8
	elif face == 3:
		$StaticBody2D/Sprite2D.frame = 3
		$StaticBody2D/CollisionShape2D.position.x = -8
		$StaticBody2D/LightOccluder2D.position.x = -8
	else:
		$StaticBody2D/Sprite2D.frame = 0




func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$StaticBody2D.visible = true
	$StaticBody2D.process_mode = Node.PROCESS_MODE_INHERIT


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$StaticBody2D.visible = false
	$StaticBody2D.process_mode = Node.PROCESS_MODE_DISABLED
