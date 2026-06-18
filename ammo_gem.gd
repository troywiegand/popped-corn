extends RigidBody2D
signal isClicked(gridX: int, gridY:int);


@export var gridX: int;
@export var gridY: int;
@export var ammoType: String;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gem_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	ammoType = gem_types.pick_random();
	$AnimatedSprite2D.animation = ammoType;
	$AnimatedSprite2D.play()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		# Trigger drag on mouse click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			isClicked.emit(gridX, gridY);
