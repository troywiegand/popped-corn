extends Control

@onready var gem_types = Array($Sprite.sprite_frames.get_animation_names()).filter(func(x): return x!="empty")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_sprite(s):
	if s=="empty":
		$Sprite.hide()
	else:
		$Sprite.animation = s;
		$Sprite.play()
		$Sprite.show()
		show()
	
func update_tooltip(s):
	mouse_filter = Control.MOUSE_FILTER_STOP
	var text = "";
	if s == "bottle":
		text = "Deal some damage and leave a hazard";
	elif s == "coin":
		text = "Deal normal damage";
	elif s == "marbles":
		text = "Deal normal damage";
	elif s == "matches":
		text = "Deal Normal Damage and a little burn";
	elif s == "mint":
		text = "Could Restore A Heart"
	elif s == "screw":
		text = "Deal Little Damage and a lot of bleed"
	elif s == "tissue":
		text = "Stun an enemy"
	elif s == "empty":
		text = ""
	tooltip_text = text; 
