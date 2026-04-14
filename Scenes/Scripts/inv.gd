extends Control

@onready var game_data = SaveManager.load_game("save_file")
@onready var player_data = SaveManager.load_game("player_file")
@onready var inv_data = SaveManager.load_game("inv_file")
@onready var box = $Items/Panel/VBoxContainer
@onready var item : PackedScene = preload("uid://ci4k72w886ct3")
@onready var profile : String = "uid://0q5mlknq6fk0"
@onready var in_combat = game_data["in_combat"]

@onready var item_icon = $Control/Icon
@onready var item_name = $Control/Name
@onready var item_desc = $Control/ScrollContainer/Desc
@onready var close = $Close
@onready var use = $Control/Button

var selected

func _ready() -> void:
	if in_combat == true:
		close.visible = false
		close.disabled = true
	else: 
		close.visible = true
		close.disabled = false
		
	_update()
	

func _insert_item(item_id):
	var instance = item.instantiate()
	
	instance.id = item_id
	instance.press.connect(_item_select)
	
	box.add_child(instance)

func _item_select(id):
	SignalManager.play_sfx.emit("click_sfx")
	SignalManager.inventory_select.emit(id)
	#SignalManager.item_used.connect(_used)
	
	var icon = inv_data[id]["Sprite"]
	
	item_icon.texture = load(icon)
	item_name.text = "[b]" + str(inv_data[id]["Name"])
	item_desc.text = inv_data[id]["Desc"]
	selected = id
	
	if inv_data[id]["Type"] == "Consumable":
		use.visible = true
	else:
		use.visible = false
	

func _update():
	for child in box.get_children(): 
		child.queue_free()
	
	if in_combat == true:
		for key in inv_data.keys():
			if inv_data[key]["Type"] == "Consumable" && inv_data[key]["Quantity"] > 0:
				_insert_item(key)
	else:
		for key in inv_data.keys():
			if inv_data[key]["Quantity"] > 0:
				_insert_item(key)
	

func _on_button_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	if selected != null:
		if inv_data[selected]["Quantity"] > 0:
			inv_data[selected]["Quantity"] -= 1
			SaveManager.save_game(inv_data, "inv_file")
			inv_data = SaveManager.load_game("inv_file")
			apply_buff(selected)
			SignalManager.item_used.emit("used")
			_update()
		else:
			_update()

func _used(state):
	if game_data["in_combat"] == true:
		if state == "used":
			use.disabled = true
			use.visible = false
		elif state == "opened":
			use.disabled = false
			use.visible = true

func _on_texture_button_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	if game_data["in_combat"] == true:
		self.visible = false
	else:
		SceneLoader.load_scene(profile)

func apply_buff(id):
	print("inv buffed ", id)
	var effect = inv_data[id]["Effect"]
	
	match effect:
		"Heal":
			var heal_amount
			match id:
				"0":
					heal_amount = 0.1
				"10":
					heal_amount = 0.25
				"11":
					heal_amount = 0.25
				"2":
					heal_amount = 0.6
			player_data["player_hp"] += ((50 + (player_data["player_end"] * 2)) * heal_amount)
			SignalManager.buff.emit({"Heal": heal_amount})
			if player_data["player_hp"] > (50 + (player_data["player_end"] * 2)):
				player_data["player_hp"] = (50 + (player_data["player_end"] * 2))
		"Max_Health":
			SignalManager.buff.emit("Max_Health")
		"Damage_Reduction":
			SignalManager.buff.emit("Damage_Reduction")
		"Damage":
			SignalManager.buff.emit("Damage")
		"Crit_Chance":
			SignalManager.buff.emit("Crit_Chance")
		"Crit_Damage":
			SignalManager.buff.emit("Crit_Damage")
		"Stat":
			player_data["unused_stats"] += 5
		"Walk_Speed":
			player_data["walk_buff"] = 180
	
	SaveManager.save_game(player_data, "player_file")
	SaveManager.save_game(game_data, "save_file")
