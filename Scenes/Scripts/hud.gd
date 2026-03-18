extends CanvasLayer

@export var animation_player: AnimationPlayer

func _ready() -> void:
	
	if SaveManager.game_data["new_game"] == true:
		$HUD.visible = false
		await animation_player.animation_finished
		await get_tree().create_timer(6).timeout
		
		animation_player.play_backwards("cutscene")
		await animation_player.animation_finished
		$Panels.visible = false
		
		$HUD.visible = true
		animation_player.play("hud_fade")
		await animation_player.animation_finished
	
