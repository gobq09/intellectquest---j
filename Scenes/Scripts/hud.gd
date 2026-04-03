extends CanvasLayer

@export var animation_player: AnimationPlayer
@onready var hud : Control = $HUD
@onready var game_data = SaveManager.load_game("save_file")

func _ready() -> void:
	if game_data["new_game"] == true:
		hud.visible = false
		animation_player.play("cutscene")
		await animation_player.animation_finished
		await get_tree().create_timer(6).timeout
		
		animation_player.play_backwards("cutscene")
		await animation_player.animation_finished
		$Panels.visible = false
		
		hud.visible = true
		animation_player.play("hud_fade")
		await animation_player.animation_finished
	
	hud.visible = true
	hud.modulate.a = 1.0
	
