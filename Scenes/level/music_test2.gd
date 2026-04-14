extends Area2D

@onready var game_data = SaveManager.load_game("save_file")
@onready var ambience = preload("res://Audio/ambience/Ocean with Seaguls.mp3")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("entered")
	#SignalManager.play_music.emit("exploration_theme")
	AudioManager.play_ambience(ambience)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not game_data["in_game"]:
			return
		AudioManager.stop_ambiance_fade()
