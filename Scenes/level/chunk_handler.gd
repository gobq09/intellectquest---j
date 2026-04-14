extends Node2D

@onready var game_data = SaveManager.load_game("save_file")
var x_axis : Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var y_axis : Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]

func _ready() -> void:
	SignalManager.entered_chunk.connect(changed_chunk)
	SignalManager.show_chunk.connect(show_chunk)

func changed_chunk(chunk_name: String):
	pass
	#var neighbors = get_neighbors(chunk_name)
	
	#SignalManager.show_chunk.emit(neighbors)

func get_chunk(chunk: String):
	var split : Array = chunk.split("_")
	
	var result : Array  = [split[1].substr(0, 1), split[1].substr(1, 1)]
	return result

func get_neighbors(chunk_name: String):
	var chunk = get_chunk(chunk_name)
	var chunk_x : String = chunk[0]
	var chunk_y : String = chunk[1]
	
	var x_index : = x_axis.find(chunk_x)
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
	#for child in get_children():
		##print(child, " hidden")
		#child.visible = false
		#child.process_mode = Node.PROCESS_MODE_DISABLED
	
	for child in get_children():
		if chunks.has(child.name):
			#print(child.name, " shown")
			if child.visible == false:
				child.visible = true
				child.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			child.visible = false
			child.process_mode = Node.PROCESS_MODE_DISABLED
