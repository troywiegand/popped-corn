extends Node2D

signal readyToFire
signal gameOver

var protag_health = 3;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EnemyHighway.spawn_enemies();
	$FireButton.hide();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_ammo_grid_made_ammo(ammo: Variant) -> void:
	print(ammo)
	for a in ammo:
		if $Harness.load_ammo(a):
			## Emit a Signal to Game Node to stop Matching
			readyToFire.emit();
			$FireButton.show();
			return
	pass # Replace with function body.


func _on_fire_button_pressed() -> void:
	$Harness.fire_ammo($EnemyHighway.enemies);
	$FireButton.hide();
	$EnemyHighway.next_turn();
	pass # Replace with function body.


func _on_harness_fire_health(strength: int) -> void:
	if strength == 3:
		print("can heal from 2 to 3")
		if protag_health == 2:
			protag_health = 3;
			$CornHeart1.animation="default";
			$CornHeart1.play();
	elif strength == 4:
		print("can heal from 2->3 or 1->2")
		if protag_health == 2:
			protag_health = 3;
			$CornHeart1.animation="default";
			$CornHeart1.play();
		if protag_health == 1:
			protag_health = 2;
			$CornHeart2.animation="default";
			$CornHeart2.play();
	elif strength == 5:
		print("can heal from 2->3 or 1->3")
		if protag_health == 1:
			protag_health = 2;
			$CornHeart2.animation="default";
			$CornHeart2.play();
		if protag_health == 2:
			protag_health = 3;
			$CornHeart1.animation="default";
			$CornHeart1.play();
	else:
		print("weak sauce heal no effect")
	pass # Replace with function body.


func _on_enemy_highway_deal_damage() -> void:
	if protag_health == 3:
		$CornHeart1.animation="empty";
		$CornHeart1.play();
		protag_health = 2;
	elif protag_health == 2:
		$CornHeart2.animation="empty";
		$CornHeart2.play();
		protag_health = 1;
	elif protag_health == 1:
		$CornHeart3.animation="empty";
		$CornHeart3.play();
		protag_health = 0;
		gameOver.emit();
	pass # Replace with function body.
