extends Node2D

@export var enemy_id: String
@export_enum("small", "med", "large") var enemy_type: String
@export_enum("English", "Science", "Math", "Filipino") var enemy_subject: String

@export var speed = 30
@export var battle_scene = "res://Scenes/combat.tscn"

@onready var enemy = $enemy

func _ready() -> void:
	enemy._set_enemy(enemy_id, enemy_type, enemy_subject)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy.process_mode = Node.PROCESS_MODE_INHERIT


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	enemy.process_mode = Node.PROCESS_MODE_DISABLED
