extends AnimatedSprite2D

@export var showHarness = false;

signal fullAmmo;
signal fireHealth(strength: int);

### 1 2
### 3 4
static var loadedAmmo = [null,null,null,null];
static var slotEffects = [0,0,0,0];

## heal h
## damage d
## linger l
## bleed/burn b
## stun s
var ammoScale = {
	"bottle": {"l":0.3,"d":0.5,"h":0,"b":0,"s":0},
	"coin": {"l":0,"d":1,"h":0,"b":0,"s":0},
	"marbles": {"l":0,"d":1,"h":0,"b":0,"s":0},
	"matches": {"l":0,"d":1,"h":0,"b":0.5,"s":0},
	"mint": {"l":0,"d":0,"h":0.1,"b":0,"s":0},
	"screw": {"l":0,"d":0.5,"h":0,"b":2,"s":0},
	"tissue": {"l":0,"d":1,"h":0,"b":0,"s":0.1},
}

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
	if where_null+1 == 4:
		return false
	return true

func fire_ammo(enemies):
	print(enemies)
	for s in enemies:
		for e in enemies[s]:
			if is_instance_valid(e) and e.slot != -1 and loadedAmmo[e.slot-1] !=null:
				var this_type = loadedAmmo[e.slot-1].type
				var this_power = loadedAmmo[e.slot-1].power 
				print("Effecting ",e.fruitType," with a shot ",this_type, " of strength ",this_power)
				var this_scaling = ammoScale[this_type];
				print(this_scaling);
				print("Taking damage: ",ceil(this_power * this_scaling["d"]) + e.dot + slotEffects[e.slot-1])
				print("Will take later: ", ceil(this_power*this_scaling["b"]))
				e.remainingHealth -= int(ceil(this_power * this_scaling["d"]) + e.dot + slotEffects[e.slot-1]);
				e.dot += ceil(this_power*this_scaling["b"]);
				e.isStunned = this_scaling["s"] > 0;
	for s in len(loadedAmmo):
		if loadedAmmo[s] != null:
			var this_slot = loadedAmmo[s];
			var this_scaling = ammoScale[this_slot.type];
			slotEffects[s] = ceil(this_scaling["l"]*this_slot.power)
			if this_scaling["h"] > 0:
				fireHealth.emit(this_slot.power)
			
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
	var this_type = a.type if a!=null and "type" in a else "empty";
	print("Loading ",this_type," into ",n)
	if this_type == "empty":
		this_slot.hide();
	else:
		this_slot.animation = this_type;
		this_slot.play();
		this_slot.show();
