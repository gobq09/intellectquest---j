extends Control

@onready var button1 = $Panel/Control/Button
@onready var button2 = $Panel/Control/Button2
@onready var button3 = $Panel/Control/Button3

@onready var hide = $Hide
@onready var panel = $Panel
var panel_hidden = false

func _on_button_pressed() -> void:
	SignalManager.dialogue_enter.emit()
	print("movement disabled")


func _on_button_2_pressed() -> void:
	SignalManager.dialogue_exit.emit()


func _on_button_3_pressed() -> void:
	SignalManager.player_look_at.emit("Bob")


func _on_button_4_pressed() -> void:
	SignalManager.player_look_at.emit("Jeff")


func _on_button_5_pressed() -> void:
	SignalManager.look_at_player.emit("Jeff")


func _on_button_6_pressed() -> void:
	SignalManager.move_to_marker.emit("Bob Marker")

func _on_hide_pressed() -> void:
	if panel_hidden:
		hide.position.x = 1208
		panel.position.x = 1232
		panel_hidden = false
	else:
		hide.position.x = 936
		panel.position.x = 960
		panel_hidden = true
