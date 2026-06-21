extends AnimatedSprite2D

@export var showHarness = false;

signal fullAmmo;


### 1 2
### 3 4
static var loadedAmmo = [null,null,null,null];

var CW = [1,3,0,2];
var CCW = [2,0,3,1];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_empty_slot()
	if showHarness:
		$HarnessRotateCW.show();
		$HarnessRotateCCW.show();
	else:
		$HarnessRotateCW.hide();
		$HarnessRotateCCW.hide();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func load_ammo(a) -> bool:
	var where_null = loadedAmmo.find(null);
	print(where_null)
	if where_null < 0 or a["type"]=="empty":
		if where_null < 0:
			fullAmmo.emit();
		print("NONE EMPTY SLOTS")
		return false
	loadedAmmo[where_null] = a
	_load_ammo_into_slot(where_null+1,a)
	return true

func fire_ammo():
	
	_empty_slot()
	pass
	
	
func turn_harness(mode):
	print(loadedAmmo , " is about to turn ", mode)
	var temp_arr = [null,null,null,null];
	var turn = null;
	if mode=="CW":
		turn = CW;
	elif mode=="CCW":
		turn = CCW;
	else:
		return false
	for a in range(len(loadedAmmo)):
		print(a, loadedAmmo[a], "goes into index ", turn[a])
		temp_arr[turn[a]] = loadedAmmo[a];
		print(temp_arr)
	loadedAmmo = temp_arr;
	print(loadedAmmo)
	_rerender_slots();
	return true;

func _rerender_slots():
	for a in range(len(loadedAmmo)):
		_load_ammo_into_slot(a+1,loadedAmmo[a]);
	

func _empty_slot():
	$Slot1.hide()
	$Slot2.hide()
	$Slot3.hide()
	$Slot4.hide()
	loadedAmmo = [null,null,null,null]
	

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
	print("Loading ",a.type," into ",n)
	this_slot.animation = a.type;
	this_slot.play();
	this_slot.show();
