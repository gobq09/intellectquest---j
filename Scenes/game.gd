extends Node2D

func _ready():
	if Transition.next_spawn != "":
		var spawn_point = $SpawnPoints.get_node_or_null(Transition.next_spawn)
		if spawn_point:
			$Player.global_position = spawn_point.global_position
		# reset next_spawn so future entries can work
		Transition.next_spawn = ""
