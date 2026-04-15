extends Node

@onready var player_data = SaveManager.load_game("player_file")
@onready var player_name = player_data["player_name"]
@onready var gender = player_data["chosen"]
@onready var difficulty = player_data["difficulty"]

@onready var Mister = "Mister"
@onready var mister = "mister"
@onready var He = "He"
@onready var he = "he"
@onready var Him = "Him"
@onready var him = "him"
@onready var His = "His"
@onready var his = "his"

func _ready() -> void:
	if gender == "Female":
		Mister = "Miss"
		mister = "miss"
		He = "She"
		he = "she"
		Him = "Her"
		him = "her"
		His = "Her"
		his = "her"
	else:
		Mister = "Mister"
		mister = "mister"
		He = "He"
		He = "He"
		he = "he"
		Him = "Him"
		him = "him"
		His = "His"
		his = "his"

func update_playerdata():
	player_data = SaveManager.load_game("player_file")
	player_name = player_data["player_name"]
	gender = player_data["chosen"]
	difficulty = player_data["difficulty"]
	
	if gender == "Female":
		Mister = "Miss"
		mister = "miss"
		He = "She"
		he = "she"
		Him = "Her"
		him = "her"
		His = "Her"
		his = "her"
	else:
		Mister = "Mister"
		mister = "mister"
		He = "He"
		He = "He"
		he = "he"
		Him = "Him"
		him = "him"
		His = "His"
		his = "his"
