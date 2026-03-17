extends Control

@onready var ques_label: Label = $Control/QuestionBg/QuestionLabel
@onready var ans_button: TextureButton = $Control/AnswerButton
@onready var ans_label: Label = $Control/AnswerButton/AnswerLabel
@onready var okay_button: TextureButton = $Control/OkButton
@onready var enemy_sprite: Sprite2D = $Enemy
@onready var player_sprite: Sprite2D = $Player
@onready var player_health_bar = $"HP/PlayerHP/$PlayerHealthBar"
@onready var enemy_health_bar= $"HP/EnemyHP/$EnemyHealthBar"
@onready var ui = $Control
@onready var panel = $Panel

# Health values
var player_health = 100
var player_max_health = 100
var enemy_health = 100
var enemy_max_health = 100

# Damage amounts
var player_damage = 100
var enemy_damage = 100

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

var question_type = Questions.questions_english_elementary

func _ready() -> void:
	_new_question()
	$Summary.visible = false

func _new_question() -> void:
	var question_id: int = randi_range(0, question_type.size() - 1)
	
	answers.clear()
	answers.append(question_type[question_id]["Choice1"])
	answers.append(question_type[question_id]["Choice2"])
	answers.append(question_type[question_id]["Choice3"])
	answers.append(question_type[question_id]["Choice4"])
	
	question = question_type[question_id]["Question"]
	correct_answer = question_type[question_id]["Answer"]
	
	ans_label.text = answers[0]
	ques_label.text = question
	
	ui.visible = true
	panel.visible = true
	$AnimationPlayer.play_backwards("fade")
	await $AnimationPlayer.animation_finished
	okay_button.disabled = false
	question_id += 1

func _on_answer_button_pressed() -> void:
	answers.push_back(answers.pop_at(0))
	ans_label.text = answers[0]

func _on_ok_button_pressed() -> void:
	okay_button.disabled = true
	if ans_label.text == correct_answer:
		_on_correct_answer()
	else:
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
		$AnimationPlayer.play("fade")
		await $AnimationPlayer.animation_finished
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
		$AnimationPlayer.play("fade")
		await $AnimationPlayer.animation_finished
		ui.visible = false
		panel.visible = false
		_new_question()

func shake(node: Node2D):
	var origin = node.position
	var elapsed = 0.0
	var orig = node.modulate
	
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
	_battle_summary()
	#textbox1_was_open = true
	#$"textbox".visible = true
	#winner_label.visible = true

func _on_player_defeated():
	print("Player defeated! Game over!")
	player_won = false
	_battle_summary()
	#$"textbox".visible = true
	#loser_label.visible = true

func _battle_summary():
	$Control.visible = false
	$HP.visible = false
	$Summary.visible = true
	
	$AnimationPlayer.play("summary")
	await $AnimationPlayer.animation_finished
	# summary screen
