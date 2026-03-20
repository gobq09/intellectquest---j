extends Control

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

@onready var ans_sprite: Array = [ans1, ans2, ans3, ans4]

# Health values
var player_health = 100
var player_max_health = 100
var enemy_health = 100
var enemy_max_health = 100

# Damage amounts
var player_damage = 25
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

var question_type = Questions.elem_english_questions
var question_id: int

func _ready() -> void:
	$Summary.visible = false
	_new_question()
	

func _new_question() -> void:
	okay_button.disabled = true
	ans_button1.disabled = true
	question_id = randi_range(0, question_type.size() - 1)
	
	answers.clear()
	answers.append(question_type[question_id]["Ans1"])
	answers.append(question_type[question_id]["Ans2"])
	answers.append(question_type[question_id]["Ans3"])
	answers.append(question_type[question_id]["Ans4"])
	
	print(question_type[question_id]["TopicID"])
	
	question = question_type[question_id]["Question"]
	correct_answer = question_type[question_id]["Correct"]
	
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
	if ans_label.text == correct_answer:
		encountered_questions[encountered_questions.size() + 1] = {
		"Question_ID" : question_id, 
		"Question": ques_label.text,
		"Answer" : ans_label.text,
		"Correct": true
		}
		_on_correct_answer()
	else:
		encountered_questions[encountered_questions.size() + 1] = {
		"Question_ID" : question_id, 
		"Question": ques_label.text,
		"Answer" : ans_label.text,
		"Correct": false
		}
		_on_wrong_answer()

func _on_correct_answer():
	var tween = create_tween()
	
	enemy_health -= enemy_damage
	enemy_health = max(enemy_health, 0)
	tween.tween_property(enemy_health_bar, "value", enemy_health, 0.25)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_SINE)
	shake(enemy_sprite)
	print("Correct! Enemy HP: ", enemy_health)
	if enemy_health <= 0:
		_on_enemy_defeated()
	else:
		await anim_player.animation_finished
		anim_player.play("fade")
		await anim_player.animation_finished
		ui.visible = false
		panel.visible = false
		_new_question()

func _on_wrong_answer():
	var tween = create_tween()
	
	player_health -= player_damage
	player_health = max(player_health, 0)
	tween.tween_property(player_health_bar, "value", player_health, 0.25)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_SINE)
	shake(player_sprite)
	print("Wrong! Player HP: ", player_health)
	if player_health <= 0:
		_on_player_defeated()
	else:
		set_process_input(false)
		anim_player.play("RESET")
		await anim_player.animation_finished
		anim_player.play("fade")
		await anim_player.animation_finished
		ui.visible = false
		panel.visible = false
		_new_question()

func shake(node: Node2D):
	var origin = node.position
	var elapsed = 0.0
	var orig = node.modulate
	
	okay_button.disabled = true
	ans_button1.disabled = true
	anim_player.play("RESET")
	await anim_player.animation_finished
	
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

func _battle_summary():
	$Control.visible = false
	$HP.visible = false
	$Summary/Control.modulate = Color(255, 255, 255, 0)
	$Summary.visible = true
	
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
		else:
			summary_cor = "  ❌"
		
		summary_text.text += summary_ques + "\n" + summary_ans + summary_cor + "\n\n"
		count += 1
		exp_gain += randi_range(1, 10)
		await get_tree().create_timer(2).timeout
	
	summary_text.text += "Experience Gained: " + str(exp_gain) + "\n\n"
	
	await get_tree().create_timer(2).timeout
	
	anim_player.play("confirm_fade")

func _on_texture_button_pressed() -> void:
	anim_player.play("summary_confirm")
	await anim_player.animation_finished
	SceneLoader.load_scene("uid://x8j1q0cr8ykf")
