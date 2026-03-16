extends Control

@onready var knob = $Knob

var radius = 80
var direction = Vector2.ZERO
var dragging = false

func _input(event):

	if event is InputEventScreenTouch:
		if event.pressed:
			var rect = Rect2(global_position, size)
			if rect.has_point(event.position):
				dragging = true
		else:
			dragging = false
			direction = Vector2.ZERO
			knob.position = Vector2.ZERO

	if event is InputEventScreenDrag and dragging:
		var offset = event.position - global_position
		offset = offset.limit_length(radius)

		knob.position = offset
		direction = offset / radius
