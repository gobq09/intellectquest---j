extends Control

#region variables

@onready var anim_player = $AnimationPlayer
@onready var help_button = $Help
@onready var help_panel = $Button
@onready var close_button = $Close
@onready var name_label = $Control/Control/Name
@onready var level_counter = $Control/Control/Level
@onready var exp_counter = $Control/Control/Exp
@onready var exp_bar = $Control/Control/ProgressBar
@onready var player_sprite = $Control/Sprite2D
@onready var reset = $Control/Reset
@onready var confirm = $Control/Confirm
@onready var unused_stat_counter = $"Control/Stats/UnusedStat"
@onready var int_label = $Control/Stats/Intelligence
@onready var end_label = $Control/Stats/Endurance
@onready var wis_label = $Control/Stats/Wisdom
@onready var str_label = $Control/Stats/Strength
@onready var int_button_add = $Control/Stats/Control/Int_Buttons/add
@onready var int_button_sub = $Control/Stats/Control/Int_Buttons/sub
@onready var int_button_label = $Control/Stats/Control/Int_Buttons/counter
@onready var end_button_add = $Control/Stats/Control/End_Buttons/add
@onready var end_button_sub = $Control/Stats/Control/End_Buttons/sub
@onready var end_button_label = $Control/Stats/Control/End_Buttons/counter
@onready var wis_button_add = $Control/Stats/Control/Wis_Buttons/add
@onready var wis_button_sub = $Control/Stats/Control/Wis_Buttons/sub
@onready var wis_button_label = $Control/Stats/Control/Wis_Buttons/counter
@onready var str_button_add = $Control/Stats/Control/Str_Buttons/add
@onready var str_button_sub = $Control/Stats/Control/Str_Buttons/sub
@onready var str_button_label = $Control/Stats/Control/Str_Buttons/counter
@onready var sprite = $Control/Sprite2D

@onready var player_data = SaveManager.load_game("player_file")
@onready var player_int : int = player_data["player_int"]
@onready var player_end : int = player_data["player_end"]
@onready var player_wis : int = player_data["player_wis"]
@onready var player_str : int = player_data["player_str"]
@onready var level : int = player_data["player_level"]
@onready var exp = player_data["player_exp"]
@onready var exp_require: float
@onready var unused_stat : int = player_data["unused_stats"]
@onready var game_data =SaveManager.load_game("save_file")
@onready var last_scene = game_data["last_scene"]

@onready var male_texture: Texture2D = preload("res://Sprites/player/sprite-playermale.png")
@onready var female_texture: Texture2D = preload("res://Sprites/player/sprite-playerfemale.png")

#@export var unused_stat: int = 10

var int_counter: int
var end_counter: int
var wis_counter: int
var str_counter: int

#endregion

func _ready() -> void:
	game_data["in_combat"] = false
	SaveManager.save_game(game_data, "save_file")
	
	if player_data["chosen"] == "Female":
		sprite.texture = female_texture
	else:
		sprite.texture = male_texture
	
	name_label.text = "[b]Name:[/b] " + player_data["player_name"]
	level_counter.text = "[b]Level:[/b] " + str(level)
	
	exp_require = round(level * 15.5)
	
	exp_counter.text = "[b]Exp:[/b] " + str(exp) + "/" + str(exp_require)
	exp_bar.value = (exp / exp_require) * 100
	
	unused_stat_counter.text = "[b]Unused Stat Points:[/b] " + str(unused_stat)
	int_label.text = "[b]Intelligence:[/b] " + str(player_int)
	end_label.text = "[b]Endurance:[/b] " + str(player_end)
	wis_label.text = "[b]Wisdom:[/b] " + str(player_wis)
	str_label.text = "[b]Strength:[/b] " + str(player_str)
	
	if unused_stat == 0:
		$Control/Stats/Control.visible = false
	else:
		$Control/Stats/Control.visible = true

#region help
func _on_help_pressed() -> void:
	help_panel.visible = true
	anim_player.play("fade")


func _on_button_pressed() -> void:
	anim_player.play_backwards("fade")
	await anim_player.animation_finished
	help_panel.visible = false
#endregion

func _on_close_pressed() -> void:
	SceneLoader.load_scene(last_scene)

#region stat
func _on_reset_pressed() -> void:
	unused_stat += int_counter
	unused_stat += end_counter
	unused_stat += wis_counter
	unused_stat += str_counter
	
	unused_stat_counter.text = "[b]Unused Stat Points:[/b] " + str(unused_stat)
	
	int_button_label.text = "0"
	end_button_label.text = "0"
	wis_button_label.text = "0"
	str_button_label.text = "0"
	
	int_counter = 0
	end_counter = 0
	wis_counter = 0
	str_counter = 0
	
	int_button_sub.disabled = true
	end_button_sub.disabled = true
	wis_button_sub.disabled = true
	str_button_sub.disabled = true
	
	int_button_add.disabled = false
	end_button_add.disabled = false
	wis_button_add.disabled = false
	str_button_add.disabled = false


func _on_confirm_pressed() -> void:
	player_int += int(int_button_label.text)
	player_end += int(end_button_label.text)
	player_wis += int(wis_button_label.text)
	player_str += int(str_button_label.text)
	
	int_label.text = "[b]Intelligence:[/b] " + str(player_int)
	end_label.text = "[b]Endurance:[/b] " + str(player_end)
	wis_label.text = "[b]Wisdom:[/b] " + str(player_wis)
	str_label.text = "[b]Strength:[/b] " + str(player_str)
	
	int_counter = 0
	end_counter = 0
	wis_counter = 0
	str_counter = 0
	
	int_button_label.text = "0"
	end_button_label.text = "0"
	wis_button_label.text = "0"
	str_button_label.text = "0"
	
	int_button_sub.disabled = true
	end_button_sub.disabled = true
	wis_button_sub.disabled = true
	str_button_sub.disabled = true
	
	if unused_stat == 0:
		int_button_add.disabled = true
		end_button_add.disabled = true
		wis_button_add.disabled = true
		str_button_add.disabled = true
	else: 
		int_button_add.disabled = false
		end_button_add.disabled = false
		wis_button_add.disabled = false
		str_button_add.disabled = false
	
	player_data["unused_stats"] = unused_stat
	player_data["player_int"] = player_int
	player_data["player_end"] = player_end
	player_data["player_wis"] = player_wis
	player_data["player_str"] = player_str
	player_data["player_hp"] += player_end * 2
	
	SaveManager.save_game(player_data, "player_file")
	
#endregion

#region stat_add

func _on_int_add_pressed() -> void:
	if unused_stat == 0:
		int_button_add.disabled = true
		int_button_sub.disabled = true
		return
	else:
		int_counter += 1
		unused_stat -= 1
		unused_stat_counter.text = "[b]Unused Stat Points:[/b] " + str(unused_stat)
		int_button_label.text = str(int_counter)
		int_button_sub.disabled = false
		
		if unused_stat == 0:
			int_button_add.disabled = true


func _on_int_sub_pressed() -> void:
	int_counter -= 1
	unused_stat += 1
	unused_stat_counter.text = "[b]Unused Stat Points:[/b] " + str(unused_stat)
	int_button_label.text = str(int_counter)
	
	if int_counter == 0:
		int_button_sub.disabled = true
	
	int_button_add.disabled = false


func _on_end_add_pressed() -> void:
	if unused_stat == 0:
		end_button_add.disabled = true
		end_button_sub.disabled = true
		return
	else:
		end_counter += 1
		unused_stat -= 1
		unused_stat_counter.text = "[b]Unused Stat Points:[/b] " + str(unused_stat)
		end_button_label.text = str(end_counter)
		end_button_sub.disabled = false
		
		if unused_stat == 0:
			end_button_add.disabled = true


func _on_end_sub_pressed() -> void:
	end_counter -= 1
	unused_stat += 1
	unused_stat_counter.text = "[b]Unused Stat Points:[/b] " + str(unused_stat)
	end_button_label.text = str(end_counter)
	
	if end_counter == 0:
		end_button_sub.disabled = true
	
	end_button_add.disabled = false


func _on_wis_add_pressed() -> void:
	if unused_stat == 0:
		wis_button_add.disabled = true
		wis_button_sub.disabled = true
		return
	else:
		wis_counter += 1
		unused_stat -= 1
		unused_stat_counter.text = "[b]Unused Stat Points:[/b] " + str(unused_stat)
		wis_button_label.text = str(wis_counter)
		wis_button_sub.disabled = false
		
		if unused_stat == 0:
			wis_button_add.disabled = true


func _on_wis_sub_pressed() -> void:
	wis_counter -= 1
	unused_stat += 1
	unused_stat_counter.text = "[b]Unused Stat Points:[/b] " + str(unused_stat)
	wis_button_label.text = str(wis_counter)
	
	if wis_counter == 0:
		wis_button_sub.disabled = true
	
	wis_button_add.disabled = false


func _on_str_add_pressed() -> void:
	if unused_stat == 0:
		str_button_add.disabled = true
		str_button_sub.disabled = true
		return
	else:
		str_counter += 1
		unused_stat -= 1
		unused_stat_counter.text = "[b]Unused Stat Points:[/b] " + str(unused_stat)
		str_button_label.text = str(str_counter)
		str_button_sub.disabled = false
		
		if unused_stat == 0:
			str_button_add.disabled = true


func _on_str_sub_pressed() -> void:
	str_counter -= 1
	unused_stat += 1
	unused_stat_counter.text = "[b]Unused Stat Points:[/b] " + str(unused_stat)
	str_button_label.text = str(str_counter)
	
	if str_counter == 0:
		str_button_sub.disabled = true
	
	str_button_add.disabled = false
#endregion


func _on_inventory_pressed() -> void:
	SceneLoader.load_scene("uid://gbgxli02186y")
