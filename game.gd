extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PopMode.hide()
	$GemMode.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_main_menu_start_game() -> void:
	$MainMenu.hide()
	$GemMode.show()
	$AudioStreamPlayer.play()
	pass # Replace with function body.


func _on_gem_mode_game_over(score: int) -> void:
	$AudioStreamPlayer.stop()
	$GemMode.hide()
	$MainMenu.show()
	$MainMenu.on_gem_mode_game_over(score)
	$GemMode.get_tree().reload_current_scene()
	pass # Replace with function body.
