extends Control

signal startGame;

var high_score = -1;
var last_score = -1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	startGame.emit();
	pass # Replace with function body.


func on_gem_mode_game_over(score: int) -> void:
	last_score = score
	if last_score > high_score:
		high_score = last_score
	$GameScore.text = "High Score: "+str(high_score)+" Last Score: "+str(last_score) 
	$GameScore.show()
	pass # Replace with function body.
