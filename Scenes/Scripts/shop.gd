extends Control

@onready var position_data = SaveManager.load_game("position_file")
@onready var player_data = SaveManager.load_game("player_file")
@onready var inv_data = SaveManager.load_game("inv_file")
@onready var item_data = SaveManager.inv_data
@onready var box = $Control/Items/Panel/VBoxContainer
@onready var item : PackedScene = preload("uid://ba6jq88wt51m4")

@onready var gold = $Control/Items/Gold
@onready var buy_amount = $Control/Control/Bulk/Amount
@onready var item_icon = $Control/Control/Icon
@onready var item_name = $Control/Control/Name
@onready var item_desc = $Control/Control/ScrollContainer/Desc
@onready var close = $Close
@onready var use = $Control/Control/Button

var regex = RegEx.new()
var old_text = ""

var selected

func _ready() -> void:
	regex.compile("^[0-9]*$")
	gold.text = abbreviate_number(int(player_data["gold"]))
	_item_list()

func abbreviate_number(n: float) -> String:
	if n >= 1_000_000_000:
		return str(snapped(n / 1_000_000_000, 0.1)) + "B"
	elif n >= 1_000_000:
		return str(snapped(n / 1_000_000, 0.1)) + "M"
	elif n >= 1_000:
		return str(snapped(n / 1_000, 0.1)) + "k"
	else:
		return str(int(n))

func _item_list():
	for child in box.get_children():
		child.queue_free()
	
	for key in item_data.keys():
		_insert_item(key)

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
	item_name.text = "[b]" + str(item_data[id]["Name"])
	item_desc.text = item_data[id]["Desc"]
	
	if selected != null:
		if not selected == id:
			if bulk(1) > 0:
				buy_amount.text = str(int(1))
			else:
				buy_amount.text = str(int(0))
	
	selected = id

	if inv_data[id]["Type"] == "Consumable":
		use.visible = true
	else:
		use.visible = false
	


func _on_button_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	if selected != null:
		if player_data["gold"] >= (int(buy_amount.text) * item_data[selected]["Price"]):
			inv_data[selected]["Quantity"] += int(buy_amount.text)
			
			player_data["gold"] -= (int(buy_amount.text) * item_data[selected]["Price"])
			
			SaveManager.save_game(player_data, "player_file")
			SaveManager.save_game(inv_data, "inv_file")
			
			inv_data = SaveManager.load_game("inv_file")
			gold.text = "Gold: " + str(int(player_data["gold"]))
			_item_list()
			_item_select(selected)
		#else:
			#_update()


#region Bulk

func bulk(limit: int):
	if selected != null:
		print(selected)
		var count : int = int(buy_amount.text)
		var cost = item_data[selected]["Price"]
		var total_cost = count * cost
		
		print("cost: ",cost)
		if player_data["gold"] >= cost:
			if limit == -1:
				while (total_cost + cost) <= player_data["gold"]:
					total_cost += cost
					count += 1
			else:
				while (total_cost + cost) <= player_data["gold"] && count < limit:
					total_cost += cost
					count += 1
		else:
			count = 0
		
		print("total cost: ",total_cost)
		return count

func _on_min_pressed() -> void:
	if selected != null:
		if bulk(1) > 0:
			buy_amount.text = str(int(1))
		else:
			buy_amount.text = str(int(0))


func _on_minus_10_pressed() -> void:
	if selected != null:
		if not int(buy_amount.text) == 0:
			
			if int(buy_amount.text) - 10 <= 0:
				if bulk(1) > 0:
					buy_amount.text = str(int(1))
				else:
					buy_amount.text = str(int(0))
			else:
				buy_amount.text = str(int(buy_amount.text) - 10)
		


func _on_minus_pressed() -> void:
	if selected != null:
		if not int(buy_amount.text) == 0:
			if int(buy_amount.text) - 1 <= 0:
				if bulk(1) > 0:
					buy_amount.text = str(int(1))
				else:
					buy_amount.text = str(int(0))
			else:
				buy_amount.text = str(int(buy_amount.text) - 1)


func _on_add_pressed() -> void:
	if selected != null:
		buy_amount.text = str(bulk(int(buy_amount.text) + 1))
	


func _on_add_10_pressed() -> void:
	if selected != null:
		buy_amount.text = str(bulk(int(buy_amount.text) + 10))

func _on_max_pressed() -> void:
	if selected != null:
		buy_amount.text = str(bulk(int(-1)))
	
#endregion

func _on_amount_text_changed(new_text: String) -> void:
	if regex.search(new_text):
		old_text = new_text
	else:
		buy_amount.text = old_text
		buy_amount.caret_column = buy_amount.text.length()


func _on_close_pressed() -> void:
	SignalManager.play_sfx.emit("click_sfx")
	SceneLoader.load_scene(position_data["last_scene"])
