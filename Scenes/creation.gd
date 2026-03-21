extends Control

#region Variables

@onready var transition: Panel = $Transition
@onready var transition_anim: AnimationPlayer = $Transition/AnimationPlayer

@onready var prologue_panel: Control = $Prologue
@onready var prologue_text: RichTextLabel = $Prologue/RichTextLabel
@onready var prologue_skip: Button = $Prologue/Button
@onready var prologue_anim: AnimationPlayer = $Prologue/AnimationPlayer

@onready var choose: Control = $Control
@onready var name_panel: Control = $Name
@onready var male_button: Button = $Control/Control/Male
@onready var female_button: Button = $Control/Control/Female
@onready var male_anim: AnimationPlayer = $Control/Control/Male/Sprite2D/AnimationPlayer
@onready var female_anim: AnimationPlayer = $Control/Control/Female/Sprite2D2/AnimationPlayer
@onready var male_sprite: Sprite2D = $Control/Control/Male/Sprite2D
@onready var female_sprite: Sprite2D = $Control/Control/Female/Sprite2D2
@onready var anim_player: AnimationPlayer = $Control/AnimationPlayer
@onready var confirm_button: Button = $Control/Button
@onready var diff_next: Button = $Name/Control/Next
@onready var diff_prev: Button = $Name/Control/Previous
@onready var diff_label: RichTextLabel = $Name/Control/Diff
@onready var name_input: TextEdit = $"Name/Name Input"
@onready var confirm1_button: Button = $Name/Confirm

#endregion

var chosen: String
var difficulties : Array = ["Elementary", "Junior Highschool", "Senior Highschool", "College"]
var i: int = 0
var player_name: String = "Quinn"

#region Prologue
func _ready() -> void:
	transition.visible = false
	prologue_anim.play("prologue")
	prologue_skip.visible = false
	await get_tree().create_timer(2).timeout
	prologue_skip.visible = true

func _on_skip_pressed() -> void:
	prologue_anim.stop()
	prologue_panel.visible = false
	transition.visible = true
	transition_anim.play("transition")
	await transition_anim.animation_finished
	
	choose.visible = true
	transition_anim.play_backwards("transition")
	await transition_anim.animation_finished
	transition.visible = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	transition.visible = true
	transition_anim.play("transition")
	await transition_anim.animation_finished
	prologue_panel.visible = false
	
	choose.visible = true
	transition_anim.play_backwards("transition")
	await transition_anim.animation_finished
	transition.visible = false
#endregion

#region Choose Character
func _on_male_pressed() -> void:
	if chosen == "Male":
		return
	anim_player.play_backwards("fade")
	male_anim.play("player_walk-down")
	female_anim.play("player_idle")
	male_sprite.z_index = 2
	female_sprite.z_index = 1
	
	chosen = "Male"
	
	confirm_button.visible = true


func _on_female_pressed() -> void:
	if chosen == "Female":
		return
	
	anim_player.play("fade")
	female_anim.play("player_walk-down")
	male_anim.play("player_idle")
	female_sprite.z_index = 2
	male_sprite.z_index = 1
	
	chosen = "Female"
	
	confirm_button.visible = true

func _on_button_pressed() -> void:
	confirm_button.visible = false
	transition.visible = true
	transition_anim.play("transition")
	await transition_anim.animation_finished
	choose.visible = false
	
	confirm1_button.visible = false
	name_panel.visible = true
	transition_anim.play_backwards("transition")
	await transition_anim.animation_finished
	transition.visible = false
	
	await get_tree().create_timer(2).timeout
	confirm1_button.visible = true
	#PlayerQuestions.copy_questions(diff)
#endregion

#region Name Input

func _on_next_pressed() -> void:
	if i == 3:
		i = 0
	else:
		i += 1
	diff_label.text = difficulties[i]


func _on_previous_pressed() -> void:
	if i == 0:
		i = 3
	else:
		i -= 1
	diff_label.text = difficulties[i]


func _on_confirm_pressed() -> void:
	confirm1_button.visible = false
	name_input.editable = false
	diff_next.disabled = true
	diff_prev.disabled = true
	player_name = name_input.text
	
	SaveManager.game_data = SaveManager.default_game_data
	SaveManager.game_data["chosen"] = chosen
	SaveManager.game_data["player_name"] = player_name
	SaveManager.game_data["difficulty"] = diff_label.text
	
	SaveManager.save_game(SaveManager.game_data)
	await get_tree().create_timer(2).timeout
	
	SceneLoader.load_scene("uid://dt532wlk4w78h")
#endregion
