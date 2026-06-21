extends Node2D

@export var enemies = [];
@export var enemy_scene: PackedScene = preload("res://fruitzioso.tscn");

signal dealDamage;

var rate_to_make_two = 0.3;
var slotsUnfillable = []; 

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
		add_child(e)
		e.show();
		enemies.append(e)
	
func next_turn():
	enemies.sort_custom(func(x,y): return x.slot > y.slot)
	for e in enemies:
		e.update_tooltip()
		if e.remainingHealth <= 0:
			print("Defeated enemy ",e.fruitType);
			e.queue_free()
		elif e.isStunned:
			e.isStunned = false
			slotsUnfillable.append(e.Slot)
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
		elif e.slot == 4:
			if slotsUnfillable.find(2) > -1:
				slotsUnfillable.append(4)
				print("Unable to move forward")
			else:
				e.slot = 2
				e.position = $Slot2.position
		else:
			print("no idea what happened")
	spawn_enemies()
	slotsUnfillable = [];
	enemies = enemies.filter(func(e): e!=null);
	pass
