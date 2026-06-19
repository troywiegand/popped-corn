extends Button
@export var ammoType: String;
@export var isHighlighted: bool = false;

@onready var color_rect: ColorRect = $ColorRect
@onready var gem_types = Array($GemSprite.sprite_frames.get_animation_names())

signal isClicked(ammo_grid)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammoType = gem_types.pick_random();
	$GemSprite.animation = ammoType;
	$GemSprite.play();
	color_rect.hide();
	pass # Replace with function body.

func change_ammo_type(s: String):
	if s in gem_types:
		ammoType = s
		$GemSprite.animation = ammoType;
		$GemSprite.play();
	elif s == "random":
		ammoType = gem_types.pick_random();
		$GemSprite.animation = ammoType;
		$GemSprite.play();
	else:
		ammoType = "empty"

func _on_pressed():
	emit_signal("isClicked", self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func highlight() -> void:
	isHighlighted = !isHighlighted; 
	$ColorRect.visible = isHighlighted;
