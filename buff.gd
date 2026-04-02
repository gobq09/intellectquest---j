extends TextureButton

var sprite : Dictionary = {
	"Max_Health": "res://ui/combat/combat-buff1.png",
	"Damage_Reduction": "res://ui/combat/combat-buff5.png",
	"Damage": "res://ui/combat/combat-buff2.png",
	"Crit_Chance": "res://ui/combat/combat-buff3.png",
	"Crit_Damage": "res://ui/combat/combat-buff4.png",
}

var type : String = "Max_Health"
var turns: int = 5

func _ready() -> void:
	self.texture_normal = load(sprite[type])
	$RichTextLabel.text  = "[b]" + str(turns)


func _on_button_down() -> void:
	$RichTextLabel2.visible = true


func _on_button_up() -> void:
	$RichTextLabel2.visible = false
