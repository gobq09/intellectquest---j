extends Node2D

@export var ques_label: Label
@export var ans_button: TextureButton
@export var ans_label: Label
@export var okay_button: TextureButton
@export var enemy_sprite: Sprite2D
@export var player_sprite: Sprite2D
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
var player_damage = 50
var enemy_damage = 50

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

func _ready() -> void:
	question = "Which word is a Noun?"
	answers = ["Apple", "Run", "Blue", "Quickly"]
	correct_answer = "Apple"
	
	ques_label.text = question
	ans_label.text = answers[0]

var i = 1

func _new_question() -> void:
	$Control/AnimationPlayer.play("fade")
	await $Control/AnimationPlayer.animation_finished
	ui.visible = false
	panel.visible = false
	
	#await get_tree().create_timer(2).timeout
	
	if i == 1:
		question = "Which punctuation mark ends a question?"
		answers = ["Period(.)", "Comma(,)", "Exclamation Mark(!)", "Question Mark(?)"]
		correct_answer = "Question Mark(?)"
		ans_label.text = answers[0]
		ques_label.text = question
		i += 1
	else:
		question = "What does the word Annual mean?"
		answers = ["Every day", "Every month", "Every year", "Every week"]
		correct_answer = "Every year"
		ans_label.text = answers[0]
		ques_label.text = question
	
	ui.visible = true
	panel.visible = true
	$Control/AnimationPlayer.play_backwards("fade")
	await $Control/AnimationPlayer.animation_finished
	okay_button.disabled = false

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
	enemy_health -= enemy_damage
	enemy_health = max(enemy_health, 0)
	enemy_health_bar.value = enemy_health
	shake(enemy_sprite)
	print("Correct! Enemy HP: ", enemy_health)
	if enemy_health <= 0:
		_on_enemy_defeated()
	else:
		_new_question()

func _on_wrong_answer():
	player_health -= player_damage
	player_health = max(player_health, 0)
	player_health_bar.value = player_health
	shake(player_sprite)
	print("Wrong! Player HP: ", player_health)
	if player_health <= 0:
		_on_player_defeated()
	else:
		_new_question()

func shake(node: Node2D):
	var origin = node.position
	var elapsed = 0.0
	while elapsed < shake_duration:
		var offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		node.position = origin + offset
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	node.position = origin
	
func _on_enemy_defeated():
	print("Enemy defeated! You win!")
	player_won = true
	textbox1_was_open = true
	#$"textbox".visible = true
	#winner_label.visible = true

func _on_player_defeated():
	print("Player defeated! Game over!")
	player_won = false
	#$"textbox".visible = true
	#loser_label.visible = true
