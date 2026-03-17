extends Node2D

const SAVE_PATH := "user://simple_save.tres"

var save_game: SaveGame = null

func _ready() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		save_game = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		save_game = SaveGame.new()
	#if Transition.next_spawn != "":
		#var spawn_point = $SpawnPoints.get_node_or_null(Transition.next_spawn)
		#if spawn_point:
			#$Player.global_position = spawn_point.global_position
		## reset next_spawn so future entries can work
		#Transition.next_spawn = ""
	#print("start" + toString(Char.new_game))
	#Char.new_game = true
	#print("start1" + Char.new_game)
	#SaveGame.new_game = true
	pass
