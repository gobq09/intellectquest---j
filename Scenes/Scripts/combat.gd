extends Control

#region variables

@onready var english_questions = SaveManager.load_game("player_questions")["english_questions"]
@onready var science_questions = SaveManager.load_game("player_questions")["science_questions"]
@onready var math_questions = SaveManager.load_game("player_questions")["math_questions"]
@onready var fil_questions = SaveManager.load_game("player_questions")["fil_questions"]
@onready var game_data = SaveManager.load_game("save_file")
@onready var player_data = SaveManager.load_game("player_file")

@onready var eng_topics = Questions.english_topic
@onready var sci_topics = Questions.science_topic
@onready var math_topics = Questions.math_topic
@onready var fil_topics = Questions.fil_topic

@onready var last_scene = SaveManager.load_game("save_file")["last_scene"]
@onready var last_position = SaveManager.load_game("save_file")["global_position"]

@onready var critical: RichTextLabel = $HP/Critical
@onready var ques_label: Label = $Control/Control/QuestionBg/QuestionLabel
@onready var ans_button1: TextureButton = $Control/Control2/AnswerButton1
@onready var ans_button2: TextureButton = $Control/Control2/AnswerButton2
@onready var ans_label: Label = $Control/Control2/AnswerLabel
@onready var ans1 : Texture2D = preload("res://ui/combat/combat-answer1.png")
@onready var ans2 : Texture2D = preload("res://ui/combat/combat-answer2.png")
@onready var ans3 : Texture2D = preload("res://ui/combat/combat-answer3.png")
@onready var ans4 : Texture2D = preload("res://ui/combat/combat-answer4.png")
@onready var okay_button: TextureButton = $Control/OkButton
@onready var enemy_sprite: Sprite2D = $Back/Control/Enemy
@onready var player_sprite: Sprite2D = $Back/Control2/Player
@onready var player_health_bar = $"HP/PlayerHP/$PlayerHealthBar"
@onready var enemy_health_bar= $"HP/EnemyHP/$EnemyHealthBar"
@onready var ui = $Control
@onready var panel = $Panel
@onready var anim_player = $AnimationPlayer
@onready var player_hplabel: RichTextLabel = $HP/PlayerHP/Player_Label
@onready var enemy_hplabel: RichTextLabel = $HP/EnemyHP/Enemy_Label
@onready var portrait : Sprite2D = $"HP/PlayerHP/Interface-combat-playerportait1-male"

@onready var ans_sprite: Array = [ans1, ans2, ans3, ans4]
@onready var male_sprite: CompressedTexture2D = preload("res://ui/combat/combat_sprites/combat-player1.png")
@onready var female_sprite: CompressedTexture2D = preload("res://ui/combat/combat_sprites/combat-player2.png")
@onready var male_portrait: CompressedTexture2D = preload("res://ui/combat/interface-combat-playerportait1-male.png")
@onready var female_portrait: CompressedTexture2D = preload("res://ui/combat/interface-combat-playerportait1-female.png")

#endregion

#region more variables

@onready var player_hp = player_data["player_hp"]
@onready var player_int = player_data["player_int"]
@onready var player_end = player_data["player_end"]
@onready var player_wis = player_data["player_wis"]
@onready var player_str = player_data["player_str"]
@onready var player_level = player_data["player_level"]
@onready var player_exp = player_data["player_exp"]
@onready var unused_stats = player_data["unused_stats"]

# Player Stats
@onready var player_health : int = player_hp
@onready var player_max_health : int = 50 + (player_end * 2)
@onready var player_max_damage : int = 10 + (player_int * 2)
@onready var player_min_damage : int = player_max_damage - 5
@onready var player_damage: int
@onready var player_critchance: float = player_wis * 0.25 + 100
@onready var player_critdamage: float = 1.5 + (player_str * 0.15)

@onready var enemy_small : Texture2D = preload("res://ui/combat/combat_sprites/combat-thresher.png")
@onready var enemy_med : Texture2D = preload("res://ui/combat/combat_sprites/combat-squidbit.png")
@onready var enemy_large : Texture2D = preload("res://ui/combat/combat_sprites/combat-driftwood.png")

@onready var enemy_data = SaveManager.load_game("enemy_file")
@onready var enemy_id = enemy_data["enemy_id"]
@onready var enemy_size = enemy_data["enemy_size"]
@onready var question_subject = enemy_data["enemy_subject"]
@onready var perfect : bool = true

# Enemy Stats
var enemy_health: int
var enemy_max_health: int
var enemy_damage = 25

# Shake settings
var shake_amount = 8
var shake_duration = 0.4

# Track game state
var player_won = false
var textbox1_was_open = false

# will depend on backend with Question Key
var question: String
var answers: Array
var correct_answer: String

var encountered_questions: Dictionary

var question_type
var topic_type
var question_id: int
#endregion

#region combat load
func _ready() -> void:
	$Summary.visible = false
	
	if player_data["chosen"] == "Female":
		player_sprite.texture = female_sprite
		portrait.texture = female_portrait
	else:
		player_sprite.texture = male_sprite
		portrait.texture = male_portrait
	
	_load_enemy()
	player_health_bar.max_value = player_max_health
	enemy_health_bar.max_value = enemy_max_health
	player_hplabel.text = "[b]" + str(player_health) + " / " + str(player_max_health) +"[/b]"
	enemy_hplabel.text = "[b]" + str(enemy_health) + " / " + str(enemy_max_health) +"[/b]"
	
	_new_question()

func _load_enemy() -> void:
	if enemy_size == "small":
		enemy_sprite.texture = enemy_small
		enemy_damage = randi_range(5, 10)
		enemy_health = randi_range(15, 30)
	elif enemy_size == "med":
		enemy_sprite.texture = enemy_med
		enemy_damage = randi_range(10, 20)
		enemy_health = randi_range(30, 50)
	elif enemy_size == "large":
		enemy_sprite.texture = enemy_large
		enemy_damage = randi_range(20, 30)
		enemy_health = randi_range(50, 100)
	
	enemy_max_health = enemy_health
	enemy_health_bar.max_value = enemy_health
	
	if question_subject == "English":
		topic_type = "eng_topics"
		question_type = english_questions
	elif question_subject == "Science":
		topic_type = "sci_topics"
		question_type = science_questions
	elif question_subject == "Math":
		topic_type = "math_topics"
		question_type = math_questions
	elif question_subject == "Filipino":
		topic_type = "fil_topics"
		question_type = fil_questions
#endregion

#region combat ui
func _new_question() -> void:
	okay_button.disabled = true
	ans_button1.disabled = true
	question_id = randi_range(0, question_type.size() - 1)
	
	answers.clear()
	while not question_type.has(str(question_id)):
		question_id = randi_range(0, question_type.size() - 1)
	
	answers.append(question_type[str(question_id)]["Ans1"])
	answers.append(question_type[str(question_id)]["Ans2"])
	answers.append(question_type[str(question_id)]["Ans3"])
	answers.append(question_type[str(question_id)]["Ans4"])
	
	question = question_type[str(question_id)]["Question"]
	correct_answer = question_type[str(question_id)]["Correct"]
	
	ans_label.text = answers[0]
	ques_label.text = question
	
	ui.visible = true
	panel.visible = true
	anim_player.play_backwards("fade")
	await anim_player.animation_finished
	okay_button.disabled = false
	ans_button1.disabled = false

func _on_answer_button_1_pressed() -> void:
	ans_button1.disabled = true
	ans_button1.texture_normal = ans_sprite[0]
	ans_button2.texture_normal = ans_sprite[1]
	anim_player.play("cards_change")
	await get_tree().create_timer(0.2).timeout
	answers.push_back(answers.pop_at(0))
	ans_label.text = answers[0]
	
	await anim_player.animation_finished
	ans_button1.disabled = false
	ans_button1.texture_normal = ans_sprite[0]
	ans_button2.texture_normal = ans_sprite[1]
	ans_sprite.push_back(ans_sprite.pop_at(0))

func _on_ok_button_pressed() -> void:
	okay_button.disabled = true
	
	encountered_questions[encountered_questions.size() + 1] = {
		"Question_ID" : question_id, 
		"Question": ques_label.text,
		"Answer" : ans_label.text,
		"Correct": true,
		"TopicID": question_type[str(question_id)]["TopicID"]
	}
	
	_save_question(topic_type)
	
	if ans_label.text == correct_answer:
		encountered_questions[encountered_questions.size()]["Correct"] = true
		question_type.erase(str(question_id))
		_on_correct_answer()
	else:
		encountered_questions[encountered_questions.size()]["Correct"] = false
		_on_wrong_answer()

func _save_question(topic_type: String):
	print(int(question_type[str(question_id)]["TopicID"]))
	print(game_data[topic_type].values().has(int(question_type[str(question_id)]["TopicID"])))
	
	if not game_data[topic_type].values().has(int(question_type[str(question_id)]["TopicID"])):
		game_data[topic_type][game_data[topic_type].size() + 1] = int(question_type[str(question_id)]["TopicID"])
	
func _on_correct_answer():
	player_damage = randi_range(player_min_damage, player_max_damage)
	
	anim_player.play("RESET")
	await anim_player.animation_finished
	print("Correct! Enemy HP: ", enemy_health)
	
	set_process_input(false)
	anim_player.play("RESET")
	await anim_player.animation_finished

	anim_player.play("fade")
	await anim_player.animation_finished
	ui.visible = false
	panel.visible = false
	
	if randf_range(0, 1) <= (player_critchance / 100):
		critical.visible = true
		
		$HP/Critical/AnimationPlayer.play("show")
		shake(critical)
		await get_tree().create_timer(0.6).timeout
		
		player_damage = round(player_damage * player_critdamage)
		critical.visible = false
	
	enemy_health -= player_damage
	var tween = create_tween()
	tween.tween_property(enemy_health_bar, "value", enemy_health, 0.25)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_SINE)
	shake(enemy_sprite)
	
	if enemy_health <= 0:
		_on_enemy_defeated()
	else:
		_new_question()

func _on_wrong_answer():
	perfect = false
	player_health = round(player_health - enemy_damage)
	
	anim_player.play("RESET")
	await anim_player.animation_finished

	print("Wrong! Player HP: ", player_health)
	
	set_process_input(false)
	anim_player.play("RESET")
	await anim_player.animation_finished
	anim_player.play("fade")
	await anim_player.animation_finished
	ui.visible = false
	panel.visible = false
	
	var tween = create_tween()
	tween.tween_property(player_health_bar, "value", player_health, 0.25)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_SINE)
	shake(player_sprite)
	
	if player_health <= 0:
		_on_player_defeated()
	else:
		_new_question()
#endregion

#region combat logic
func shake(node):
	var origin = node.position
	var elapsed = 0.0
	var orig = node.modulate
	
	okay_button.disabled = true
	ans_button1.disabled = true
	
	while elapsed < shake_duration:
		var offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		node.position = origin + offset
		node.modulate = Color(255, 255, 255)
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	node.modulate = orig
	node.position = origin
	
func _on_enemy_defeated():
	print("Enemy defeated! You win!")
	player_won = true
	
	var tween = create_tween()
	
	tween.tween_property($HP, "modulate", Color(255, 255, 255, 0), 0.25)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_SINE)
	tween.tween_property($Control, "modulate", Color(255, 255, 255, 0), 0.25)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_SINE)
	
	shake(enemy_sprite)
	await get_tree().create_timer(0.5).timeout
	shake(enemy_sprite)
	await get_tree().create_timer(0.5).timeout
	shake(enemy_sprite)
	await get_tree().create_timer(0.5).timeout
	
	tween = create_tween()
	
	tween.tween_property(enemy_sprite, "modulate", Color(255, 255, 255, 0), 0.25)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(1).timeout
	
	game_data["defeated_enemies"][game_data["defeated_enemies"].size()] = enemy_id
	SaveManager.save_game(game_data, "save_file")
	_battle_summary()
	#textbox1_was_open = true
	#$"textbox".visible = true
	#winner_label.visible = true

func _on_player_defeated():
	print("Player defeated! Game over!")
	player_won = false
	
	var tween = create_tween()
	
	tween.tween_property($Control, "modulate", Color(255, 255, 255, 0), 0.25)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_SINE)
	tween.tween_property($HP, "modulate", Color(255, 255, 255, 0), 0.25)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_SINE)
	
	shake(player_sprite)
	await get_tree().create_timer(0.5).timeout
	shake(player_sprite)
	await get_tree().create_timer(0.5).timeout
	shake(player_sprite)
	await get_tree().create_timer(0.5).timeout
	
	tween = create_tween()
	
	tween.tween_property(player_sprite, "modulate", Color(255, 255, 255, 0), 0.25)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(1).timeout
	
	_battle_summary()
	#$"textbox".visible = true
	#loser_label.visible = true
#endregion

#region summary
func _battle_summary():
	$Control.visible = false
	$HP.visible = false
	$Summary/Control.modulate = Color(255, 255, 255, 0)
	$Summary.visible = true
	$Summary/Control/TextureButton.disabled = true
	
	anim_player.play("summary")
	await anim_player.animation_finished
	
	_evaluate()

func _evaluate():
	var summary_text = $Summary/Control/ScrollContainer/SummaryLabel
	var summary_ques: String
	var summary_ans: String
	var summary_cor: String
	var count: int = 1
	var exp_gain: int
	#show question
	for ques in encountered_questions:
		summary_ques = encountered_questions[count]["Question"]
		summary_ans = encountered_questions[count]["Answer"]
		if encountered_questions[count]["Correct"] == true:
			summary_cor = "  ✔"
			exp_gain += randi_range(5, 10)
		else:
			summary_cor = "  ❌"
			exp_gain += randi_range(1, 5)
		
		summary_text.text += "[b]" + summary_ques + "[/b]" + "\n" + summary_ans + summary_cor + "\n\n"
		count += 1
		
		await get_tree().create_timer(1).timeout
	
	if perfect == true:
		summary_text.text += "[b]PERFECT![/b] Bonus Exp Added.\n\n"
		exp_gain += (exp_gain * 0.1) + (player_level * 0.5)
	
	summary_text.text += "Experience Gained: " + str(exp_gain) + "\n\n"
	
	var total_exp : float = player_exp + exp_gain
	var exp_require : float = player_level * 15.5
	var level_up: int = player_level
	var stats_add: int = unused_stats
	
	while total_exp >= exp_require:
		await get_tree().create_timer(0.5).timeout
		if total_exp < exp_require:
			break
		else:
			total_exp -= exp_require
		summary_text.text += "[b]Leveled up![/b]\n"
		
		player_health = player_max_health
		level_up += 1
		stats_add += 3
		
		await get_tree().create_timer(0.5).timeout
	
	summary_text.text += "\n\n\n"
	player_data["player_level"] = level_up
	player_data["unused_stats"] = stats_add
	player_data["player_hp"] = player_health
	player_data["player_exp"] = total_exp
	SaveManager.save_game(player_data, "player_file")
	
	await get_tree().create_timer(2).timeout
	
	anim_player.play("confirm_fade")
	$Summary/Control/TextureButton.disabled = false

func _on_texture_button_pressed() -> void:
	anim_player.play("summary_confirm")
	await anim_player.animation_finished
	SceneLoader.load_scene(last_scene)
#endregion


func _on_enemy_health_bar_value_changed(value: float) -> void:
	enemy_hplabel.text = "[b]" + str(enemy_health) + " / " + str(enemy_max_health) +"[/b]"


func _on_player_health_bar_value_changed(value: float) -> void:
	player_hplabel.text = "[b]" + str(player_health) + " / " + str(player_max_health) +"[/b]"
