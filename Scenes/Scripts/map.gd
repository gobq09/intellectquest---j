extends Control

@onready var game_data = SaveManager.load_game("save_file")
@onready var anim_player = $"../../AnimationPlayer"

func _on_close_pressed() -> void:
	anim_player.play("fade")
	SceneLoader.load_scene(game_data["last_scene"])
