extends CanvasLayer

signal loading_screen_ready
@export var animation_player: AnimationPlayer

func _ready() -> void:
	#$HUD.visible = false
	await animation_player.animation_finished
	loading_screen_ready.emit()

func _on_progress_changed(_new_value: float) -> void:
	pass

func _on_load_finished() -> void:
	animation_player.play_backwards("loading")
	await animation_player.animation_finished
	#$HUD.visible = true
	queue_free()

func _process(_delta: float) -> void:
	var count: int = 6
	var repeat: int = 20
	
	while repeat != 20:
		if count != 9:
			$Label.visible_characters = count
			count += 1
			await get_tree().create_timer(1).timeout
		else:
			count = 6
		repeat += 1
