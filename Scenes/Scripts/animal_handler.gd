extends Node2D

@export var type: String = "Chicken"
@export var swim_speed: float = 80.0
@export var min_idle_time: float = 1.0
@export var max_idle_time: float = 3.0
@export var min_swim_time: float = 2.0
@export var max_swim_time: float = 5.0
@export var left_limit: float = 50.0
@export var right_limit: float = 1100.0
@export var top_limit: float = 50.0
@export var bottom_limit: float = 600.0

@onready var animal = $Animal

func _ready() -> void:
	animal._set_animal(type, swim_speed, min_idle_time, max_idle_time, min_swim_time, max_swim_time, left_limit, right_limit, top_limit, bottom_limit)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animal.process_mode = Node.PROCESS_MODE_INHERIT


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	animal.process_mode = Node.PROCESS_MODE_DISABLED
