extends Node

func _ready() -> void:
	SignalManager.interface_changed.connect(interface_changed)

func map_changed(scene, position):
	var game_data = SaveManager.load_game("save_file")
	print ("Saved ", scene)
	
	game_data["last_scene"] = scene
	game_data["in_game"] = true
	game_data["global_position"] = position
	
	SaveManager.save_game(game_data, "save_file")

func interface_changed():
	var game_data = SaveManager.load_game("save_file")
	print("Interface Change: ", game_data["last_scene"])
	SaveManager.save_game(game_data, "save_file")
