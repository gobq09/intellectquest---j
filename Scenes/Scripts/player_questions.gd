extends Node

var elem_eng_ques : Dictionary = Questions.elem_english_questions
var jhs_eng_ques : Dictionary = Questions.jhs_english_questions
var shs_eng_ques : Dictionary = Questions.shs_english_questions
var college_eng_ques : Dictionary = Questions.college_english_questions

var elem_sci_ques : Dictionary = Questions.elem_science_questions
var jhs_sci_ques : Dictionary = Questions.jhs_science_questions
var shs_sci_ques : Dictionary = Questions.shs_science_questions
var college_sci_ques : Dictionary = Questions.college_science_questions

var elem_math_ques : Dictionary = Questions.elem_english_questions
var jhs_math_ques : Dictionary = Questions.jhs_english_questions
var shs_math_ques : Dictionary = Questions.shs_english_questions
var college_math_ques : Dictionary = Questions.college_english_questions

var elem_fil_ques : Dictionary = Questions.elem_fil_questions
var jhs_fil_ques : Dictionary = Questions.jhs_fil_questions
var shs_fil_ques : Dictionary = Questions.shs_fil_questions
var college_fil_ques : Dictionary = Questions.college_fil_questions

var player_questions: Dictionary
var english_questions: Dictionary
var science_questions: Dictionary
var math_questions: Dictionary
var fil_questions: Dictionary
var clear: Dictionary

func copy_questions(diff: String = "Elementary") -> void:
	
	if diff == "Elementary" || diff == "Junior Highschool" || diff == "Senior Highschool" || diff == "College":
		english_questions.merge(elem_eng_ques, false)
		science_questions.merge(elem_sci_ques, false)
		math_questions.merge(elem_math_ques, false)
		fil_questions.merge(elem_fil_ques, false)
	
	if diff == "Junior Highschool" || diff == "Senior Highschool" || diff == "College":
		english_questions.merge(jhs_eng_ques, false)
		science_questions.merge(jhs_sci_ques, false)
		math_questions.merge(jhs_math_ques, false)
		fil_questions.merge(jhs_fil_ques, false)
	
	if diff == "Senior Highschool" || diff == "College":
		english_questions.merge(shs_eng_ques, false)
		science_questions.merge(shs_sci_ques, false)
		math_questions.merge(shs_math_ques, false)
		fil_questions.merge(shs_fil_ques, false)
	
	if diff == "College":
		english_questions.merge(college_eng_ques, false)
		science_questions.merge(college_sci_ques, false)
		math_questions.merge(college_math_ques, false)
		fil_questions.merge(college_fil_ques, false)
	
	player_questions = {
		"english_questions" = english_questions,
		"science_questions" = science_questions,
		"math_questions" = math_questions,
		"fil_questions" = fil_questions
	}
	
	SaveManager.save_game(player_questions, "player_questions")

func clear_questions() -> void:
	SaveManager.save_game(clear, "player_questions")
