extends AnimatedSprite2D

### 1 2
### 3 4
static var loadedAmmo = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_empty_slot()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_ammo(a) -> bool:
	loadedAmmo.append(a)
	_load_ammo_into_slot(len(loadedAmmo),a)
	return len(loadedAmmo) == 4

func fire_ammo():
	
	_empty_slot()
	pass
	
	
func turn_harness():
	pass

func _empty_slot():
	$Slot1.hide()
	$Slot2.hide()
	$Slot3.hide()
	$Slot4.hide()
	

func _pick_slot(n: int):
	if n==1:
		return $Slot1
	elif n==2:
		return $Slot2
	elif n==3:
		return $Slot3
	else:
		return $Slot4

func _load_ammo_into_slot(n: int, a):
	var this_slot = _pick_slot(n)
	this_slot.animation = a.type;
	this_slot.play();
	this_slot.show();
