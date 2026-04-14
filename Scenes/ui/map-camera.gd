extends Camera2D

var zoom_speed = 0.05
var min_zoom = 0.5
var max_zoom = 2.0
var touch_points = {}

func _ready():
	var panel_rect = $"../Map".get_global_rect()
	var player_pos = $"../Map/Linguara/Player".global_position
	position = Vector2(player_pos.x + 32, player_pos.y + 32)
	
	# Apply limits to the camera
	limit_left = panel_rect.position.x
	limit_top = panel_rect.position.y
	limit_right = panel_rect.end.x
	limit_bottom = panel_rect.end.y

func _input(event):
	if event is InputEventScreenTouch:
		touch_points[event.index] = event.position
		if event.pressed == false:
			touch_points.erase(event.index)
			
	elif event is InputEventScreenDrag:
		touch_points[event.index] = event.position
		
		if touch_points.size() == 1:
			# Panning
			var drag_relative = event.relative
			position -= drag_relative * zoom
			
		elif touch_points.size() == 2:
			# Pinch-to-zoom
			var p1 = touch_points[0]
			var p2 = touch_points[1]
			var dist = p1.distance_to(p2)
			
			# Simple zoom logic based on distance change
			# (Requires tracking last_dist for smooth scaling)
			# A more robust solution involves comparing current distance
			# with the distance in the previous frame
			pass

# Robust example for zooming and panning can be found in 
# community resources like KidsCanCode (3.x but adaptable)
