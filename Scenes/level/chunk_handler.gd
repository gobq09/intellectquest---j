extends Node2D

@onready var game_data = SaveManager.load_game("save_file")
var x_axis : Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var y_axis : Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]

func _ready() -> void:
	SignalManager.entered_chunk.connect(changed_chunk)
	SignalManager.show_chunk.connect(show_chunk)

func changed_chunk(chunk_name: String):
	if chunk_name == name:
		var neighbors = get_neighbors(chunk_name)
		
		SignalManager.show_chunk.emit(neighbors)

func get_chunk(chunk: String):
	var split = chunk.split("_")
	
	var result = [split[1].substr(0, 1), split[1].substr(1, 1)]
	return result

func get_neighbors(chunk_name: String):
	var chunk = get_chunk(chunk_name)
	var chunk_x = chunk[0]
	var chunk_y = chunk[1]
	
	var x_index = x_axis.find(chunk_x)
	var y_index = y_axis.find(chunk_y)
	
	#print("chunk x: ", chunk_x, "\nchunk y: ", chunk_y)
	
	var topleft_chunk = "Chunk_" + str(x_axis[x_index - 1]) + str(y_axis[y_index + 1])
	var top_chunk = "Chunk_" + str(x_axis[x_index]) + str(y_axis[y_index + 1])
	var topright_chunk = "Chunk_" + str(x_axis[x_index + 1]) + str(y_axis[y_index + 1])
	var left_chunk = "Chunk_" + str(x_axis[x_index - 1]) + str(y_axis[y_index])
	var right_chunk = "Chunk_" + str(x_axis[x_index + 1]) + str(y_axis[y_index])
	var botleft_chunk = "Chunk_" + str(x_axis[x_index - 1]) + str(y_axis[y_index - 1])
	var bot_chunk = "Chunk_" + str(x_axis[x_index]) + str(y_axis[y_index - 1])
	var botright_chunk = "Chunk_" + str(x_axis[x_index + 1]) + str(y_axis[y_index - 1])
	
	var visible_chunks: Array = [topleft_chunk, top_chunk, topright_chunk, left_chunk, chunk_name, right_chunk, botleft_chunk, bot_chunk, botright_chunk]
	return visible_chunks

func show_chunk(chunks: Array):
	if name in chunks:
		#print(name, " shown")
		self.visible = true
		self.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		#print(name, " hidden")
		self.visible = false
		self.process_mode = Node.PROCESS_MODE_DISABLED


func _on_grid_1_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		var game_data = SaveManager.load_game("save_file")
		game_data["chunk_grid"] = 1
		SaveManager.save_game(game_data, "save_file")


func _on_grid_2_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		var game_data = SaveManager.load_game("save_file")
		game_data["chunk_grid"] = 2
		SaveManager.save_game(game_data, "save_file")


func _on_grid_3_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		var game_data = SaveManager.load_game("save_file")
		game_data["chunk_grid"] = 3
		SaveManager.save_game(game_data, "save_file")


func _on_grid_4_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		var game_data = SaveManager.load_game("save_file")
		game_data["chunk_grid"] = 4
		SaveManager.save_game(game_data, "save_file")
