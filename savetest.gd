extends Control

@export var diff : String = "Elementary"

var elem_eng_ques : Dictionary = Questions.elem_english_questions
var jhs_eng_ques : Dictionary = Questions.jhs_english_questions
var shs_eng_ques : Dictionary = Questions.shs_english_questions
var college_eng_ques : Dictionary = Questions.college_english_questions

var player_questions: Dictionary
var english_questions: Dictionary
var science_questions: Dictionary
var clear: Dictionary

func _on_load_pressed() -> void:
	# get questions
	if diff == "Elementary":
		english_questions.merge(elem_eng_ques, false)
	elif diff == "Junior Highschool":
		english_questions.merge(elem_eng_ques, false)
		english_questions.merge(jhs_eng_ques, false)
	elif diff == "Senior Highschool":
		english_questions.merge(elem_eng_ques, false)
		english_questions.merge(jhs_eng_ques, false)
		english_questions.merge(shs_eng_ques, false)
	elif diff == "College":
		english_questions.merge(elem_eng_ques, false)
		english_questions.merge(jhs_eng_ques, false)
		english_questions.merge(shs_eng_ques, false)
		english_questions.merge(college_eng_ques, false)
	
	player_questions = {
		"english_questions" = english_questions,
		"science_questions" = science_questions
	}
	
	SaveManager.save_game(player_questions, "res://player_questions.json")


func _on_reset_pressed() -> void:
	SaveManager.save_game(clear, "res://player_questions.json")
	pass # Replace with function body.


func _on_display_pressed() -> void:
	print(SaveManager.load_game("res://player_questions.json"))
