extends Control

@export var animation_player: AnimationPlayer

func _ready() -> void:
	await animation_player.animation_finished
	SceneLoader.load_scene("uid://dkefgsuwak2hj")
