extends Area2D

@onready var game_data = SaveManager.load_game("save_file")
@onready var music = preload("res://Audio/Music/Town Themes/Greymoor Town.mp3")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("entered")
	#SignalManager.play_music.emit("exploration_theme")
	AudioManager.play_music(music)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not game_data["in_game"]:
			return
		SignalManager.stop_music.emit()
		_play_random_ambience()

func _play_random_ambience():
	SignalManager.play_ambience.emit("nature_ambience")
	
	var delay = randf_range(3, 8)
	await get_tree().create_timer(delay).timeout
