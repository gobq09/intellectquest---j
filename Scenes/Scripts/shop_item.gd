extends TextureButton

@onready var label = $Label
@onready var icon = $ColorRect
@onready var price = $RichTextLabel
@onready var inv_data = SaveManager.load_game("inv_file")
@onready var shop_data = SaveManager.inv_data
@onready var shop_scene : PackedScene = preload("uid://dltbuv5c8rl7a")

var id: String = "0"
var darker = Color(0.5, 0.5, 0.5, 1.0)
var normal = Color(1, 1, 1, 1.0)

signal press(id)

func _ready() -> void:
	label.text = "[b]" + str(shop_data[id]["Name"]) + "\n[/b]Owned: " +  str(int(inv_data[id]["Quantity"]))
	price.text = "[b]" + str(int(shop_data[id]["Price"]))
	var sprite = shop_data[id]["Sprite"]
	icon.texture = load(sprite)
	self_modulate = darker
	$TextureRect.self_modulate = darker

	SignalManager.inventory_select.connect(_pressed_update)

func _on_pressed() -> void:
	self_modulate = normal
	$TextureRect.self_modulate = normal
	
	press.emit(id)

func _pressed_update(button):
	if button == id:
		self_modulate = normal
		$TextureRect.self_modulate = normal
	else:
		self_modulate = darker
		$TextureRect.self_modulate = darker
