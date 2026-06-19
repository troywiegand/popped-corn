extends Node2D

signal readyToFire


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
			return
	pass # Replace with function body.
