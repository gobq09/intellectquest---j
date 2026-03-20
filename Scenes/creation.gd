extends Control

@onready var male_button: Button = $Control/Male
@onready var female_button: Button = $Control/Female
@onready var male_anim: AnimationPlayer = $Control/Male/Sprite2D/AnimationPlayer
@onready var female_anim: AnimationPlayer = $Control/Female/Sprite2D2/AnimationPlayer
@onready var male_sprite: Sprite2D = $Control/Male/Sprite2D
@onready var female_sprite: Sprite2D = $Control/Female/Sprite2D2
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var chosen: String

func _on_male_pressed() -> void:
	if chosen == "Male":
		return
	anim_player.play_backwards("fade")
	male_anim.play("player_walk-down")
	female_anim.play("player_idle")
	male_sprite.z_index = 2
	female_sprite.z_index = 1
	
	chosen = "Male"


func _on_female_pressed() -> void:
	if chosen == "Female":
		return
	
	anim_player.play("fade")
	female_anim.play("player_walk-down")
	male_anim.play("player_idle")
	female_sprite.z_index = 2
	male_sprite.z_index = 1
	
	chosen = "Female"

func _on_button_pressed() -> void:
	var diff = "Junior Highschool"
	SaveManager.save_game(SaveManager.default_game_data)
	
	PlayerQuestions.copy_questions(diff)
