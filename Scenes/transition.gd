extends CanvasLayer

@onready var anim = $AnimationPlayer
var next_spawn = ""
var next_scene = ""
var return_spawn = ""

func fade_to_scene(scene_path, spawn_id=""):
	next_scene = scene_path
	next_spawn = spawn_id
	
	anim.play("fade_out")
	await anim.animation_finished
	
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame
	
	anim.play("fade_in")
