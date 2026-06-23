extends Node2D

@export var enemies = {
	4: [],
	3: [],
	2: [],
	1: [],
	0: []
};
@export var enemy_scene: PackedScene = preload("res://fruitzioso.tscn");

signal defeatEnemy;
signal dealDamage;

var rate_to_make_two = 0.3;
var slotsUnfillable = [];
var slotEffects = [0,0,0,0];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func spawn_enemies():
	if randf() < rate_to_make_two:
		print("Spawning 2")
		add_in_enemy(true);
		add_in_enemy(false);
	else:
		print("Spawning 1")
		add_in_enemy(randf()>0.5);
	pass

func add_in_enemy(side: bool):
	var e = enemy_scene.instantiate()
	var sidePos;
	var slotNumber; 
	if side:
		sidePos = $Slot3.position;
		slotNumber = 3;
	else: 
		sidePos = $Slot4.position;
		slotNumber = 4;
	if slotsUnfillable.find(slotNumber) > -1:
		print("no room")
	else:
		e.position = sidePos;
		e.remainingHealth = randi() % 3 + 3;
		e.slot = slotNumber;
		print(slotEffects)
		e.dot = slotEffects[slotNumber-1]
		add_child(e)
		e.show();
		enemies[slotNumber].append(e)
	
func next_turn():
	print(enemies)
	for s in enemies:
		for e in enemies[s]:
			print(typeof(e))
			if not is_instance_valid(e):
				print('my guy is dead')
				continue
			if e.remainingHealth <= 0:
				print("Defeated enemy ",e.fruitType);
				defeatEnemy.emit();
				e.queue_free()
			elif e.isStunned:
				e.isStunned = false
				slotsUnfillable.append(e.slot)
			elif e.slot == 0:
				dealDamage.emit();
				e.queue_free();
			elif e.slot == 1 or e.slot == 2:
				e.slot = 0
				e.position = $Danger.position
			elif e.slot == 3:
				if slotsUnfillable.find(1) > -1:
					slotsUnfillable.append(3)
					print("Unable to move forward")
				else:
					e.slot = 1
					e.position = $Slot1.position
					e.dot += slotEffects[0]
			elif e.slot == 4:
				if slotsUnfillable.find(2) > -1:
					slotsUnfillable.append(4)
					print("Unable to move forward")
				else:
					e.slot = 2
					e.position = $Slot2.position
					e.dot += slotEffects[1]
			else:
				print("no idea what happened")
			e.update_tooltip();
	spawn_enemies()
	slotsUnfillable = [];
	pass

func toggle_glass(n,b):
	var bb = null;
	if n == 1:
		bb = $Slot1/BrokenBottle
	elif n == 2:
		bb = $Slot2/BrokenBottle
	elif n == 3:
		bb = $Slot3/BrokenBottle
	elif n == 4:
		bb = $Slot4/BrokenBottle
	if b:
		bb.show()
	else:
		bb.hide()


func _on_harness_activate_hazard(slot: int, strength:int) -> void:
	toggle_glass(slot, true)
	slotEffects[slot-1] += strength
	print(slotEffects)
	pass # Replace with function body.
