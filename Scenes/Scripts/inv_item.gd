extends TextureButton

@onready var label = $Label
@onready var icon = $ColorRect
@onready var inv_data = SaveManager.load_game("inv_file")
@onready var inv_scene : PackedScene = preload("uid://gbgxli02186y")

var id: String = "0"
var darker = Color(0.5, 0.5, 0.5, 1.0)
var normal = Color(1, 1, 1, 1.0)

signal press(id)

func _ready() -> void:
	label.text = "[b]" + str(inv_data[id]["Name"]) + "\n[/b]Quantity: " +  str(int(inv_data[id]["Quantity"]))
	var sprite = inv_data[id]["Sprite"]
	icon.texture = load(sprite)
	self_modulate = darker

	SignalManager.inventory_select.connect(_pressed_update)

func _on_pressed() -> void:
	self_modulate = normal
	
	press.emit(id)

func _pressed_update(button):
	if button == id:
		self_modulate = normal
	else:
		self_modulate = darker
