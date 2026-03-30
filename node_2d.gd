extends Node2D

@onready var sprite = $Sprite2D
@onready var die_button = $Die
@onready var start_button = $Start
@onready var timer = $Timer

var respawn_time
var dictionary = {}

func _on_die_pressed() -> void:
	# get current time
	respawn_time = Time.get_unix_time_from_system() + 10
	print("current time: " + str(Time.get_unix_time_from_system()))
	print("respawn time: " + str(respawn_time))
	
	# save current time + 5 minutes as respawn time
	dictionary = {"enemy_id": respawn_time}
	print(dictionary)
	
	sprite.visible = false


func _on_start_pressed() -> void:
	# check defeated enemies dictionary
	if dictionary.has("enemy_id"):
		print("enemy respawn: " + str(dictionary["enemy_id"]))
		if Time.get_unix_time_from_system() > dictionary["enemy_id"]:
			print("current time past respawn time, respawning")
			sprite.visible = true
		else:
			var remaining = dictionary["enemy_id"] - Time.get_unix_time_from_system()
			timer.start(remaining)
			print("respawning in: ", remaining)
	
	# if enemy_id is on dictionary
	# # check respawn time
	# # # if current time > respawn time: respawn, delete enemy_id in dictionary
	# # # else timer.timeout = current time - respawn time
	pass # Replace with function body.


func _on_time_pressed() -> void:
	print(Time.get_unix_time_from_system())


func _on_timer_timeout() -> void:
	print("respawned!")
	sprite.visible = true
	dictionary.erase("enemy_id")
	print(dictionary)
