extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		print("player entered")
		Transition.fade_to_scene("res://Scenes/game.tscn", "start_point_beach.tscn")
		
