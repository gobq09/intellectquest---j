extends Node

var elem_eng_ques : Dictionary = Questions.elem_english_questions
var jhs_eng_ques : Dictionary = Questions.jhs_english_questions
var shs_eng_ques : Dictionary = Questions.shs_english_questions
var college_eng_ques : Dictionary = Questions.college_english_questions

var player_questions: Dictionary
var english_questions: Dictionary
var science_questions: Dictionary
var math_questions: Dictionary
var fil_questions: Dictionary
var clear: Dictionary

func copy_questions(diff: String = "Elementary") -> void:
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
		"science_questions" = science_questions,
		"math_questions" = math_questions,
		"fil_questions" = fil_questions
	}
	
	SaveManager.save_game(player_questions, "res://player_questions.json")

func clear_questions() -> void:
	SaveManager.save_game(clear, "res://player_questions.json")
