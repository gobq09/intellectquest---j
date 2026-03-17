extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		print("player entered")
		SceneLoader.load_scene("uid://x8j1q0cr8ykf")
	
