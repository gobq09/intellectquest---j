extends Timer

@onready var ambience_timer: Timer = $"."

func _ready():
	_start_ambience_loop()

func _start_ambience_loop():
	_play_random_ambience()
	
func _play_random_ambience():
	SignalManager.play_ambience.emit("nature_ambience")
	
	var delay = randf_range(3, 8)
	await get_tree().create_timer(delay).timeout
