extends CanvasLayer

@export var animation_player: AnimationPlayer


func _ready() -> void:
	if SaveManager.load_game("save_file")["new_game"] == true:
		$HUD.visible = false
		animation_player.play("cutscene")
		await animation_player.animation_finished
		await get_tree().create_timer(6).timeout
		
		animation_player.play_backwards("cutscene")
		await animation_player.animation_finished
		$Panels.visible = false
		
		$HUD.visible = true
		animation_player.play("hud_fade")
		await animation_player.animation_finished
	$HUD.visible = true
	$HUD.modulate.a = 1.0
	
