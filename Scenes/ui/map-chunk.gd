extends TextureRect

@export var columns: int
@export var rows: int

@onready var player = $Player
#@onready var player_data = SaveManager.load_game("player_file")
@onready var position_data = SaveManager.load_game("position_file")
@onready var chunk = position_data["last_chunk"]
@onready var grid = position_data["chunk_grid"]

var x_axis : Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var y_axis : Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]

func _ready() -> void:
	player.position = (chunk_grid(get_chunk(chunk)))

func get_chunk(chunk: String):
	var split = chunk.split("_")
	
	var result = [split[1].substr(0, 1), split[1].substr(1, 1)]
	return result

func chunk_grid(chunk):
	var x_length = size.x
	var y_length = size.y
	var grid_w = x_length / columns
	var grid_h = y_length / rows
	var x_index : int = x_axis.find(chunk[0])
	var y_index : int = y_axis.find(chunk[1])
	
	print(chunk)
	print("Grid_w: ",grid_w)
	print("Grid_h: ",grid_h)
	
	# A = grid_w * index
	# 1 = y_length - (grid_h * index + 1)
	
	# 1 = 0, 0
	# 2 = 32, 0
	# 3 = 0, 32
	# 4 = 32, 32
	
	var x_pos = grid_w * x_index
	var y_pos = y_length - (grid_h * (y_index + 1))
	
	print("x_pos: ", x_pos)
	print("y_pos: ", y_pos)
	
	var player_pos = Vector2(x_pos, y_pos)
	print(player.position)
	
	if grid == 2:
		player_pos.x += (grid_w / 2)
	elif grid == 3:
		player_pos.y += (grid_h / 2)
	elif grid == 4:
		player_pos.x += (grid_w / 2)
		player_pos.y += (grid_h / 2)
	
	return player_pos
