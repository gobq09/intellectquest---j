extends Node2D

@export var Parent_Node: CharacterBody2D
@export var Anim_Tree: AnimationTree

func _ready() -> void:
	pass

func move_player_to(target_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(Parent_Node, "global_position", target_pos, 1.0)
	var direction = Parent_Node.global_position - target_pos
	var face: Vector2 = Vector2.ZERO
	
	if direction.x < 0:
		face.x += 1
	if direction.x > 0:
		face.x -= 1
	if direction.y < 0:
		face.y += 1
	if direction.y > 0:
		face.y -= 1
	
	Anim_Tree.get("parameters/playback").travel("Walk")
	Anim_Tree.set("parameters/Walk/blend_position", face)
	print(face)
