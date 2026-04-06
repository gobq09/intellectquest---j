extends Node2D

@onready var label = $RichTextLabel

func show_damage(value: String, color: Color = Color.WHITE):
	label.text = "[b]- " + value
	label.modulate = color

	# Use a Tween to animate movement and fading
	var tween = create_tween()
	tween.set_parallel(true)
	# Move up
	tween.tween_property(self, "position", position + Vector2(0, -50), 1.5)
	# Fade out
	tween.tween_property(label, "modulate:a", 0.0, 1.5)
	# Delete after animation
	tween.chain().tween_callback(queue_free)
