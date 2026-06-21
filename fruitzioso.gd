extends Control

@export var fruitType: String;
@onready var fruit_types = Array($FruitziosoSprite.sprite_frames.get_animation_names())
@export var remainingHealth = 0;
@export var dot = 0;
@export var slot = -1;
@export var isStunned = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fruitType = fruit_types.pick_random();
	$FruitziosoSprite.animation = fruitType;
	print("fruit ", fruitType)
	$FruitziosoSprite.play();
	update_tooltip();
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_tooltip():
	tooltip_text = "A "+fruitType+" with "+str(remainingHealth)+" HP left taking "+str(dot)+" damage next turn."; 
