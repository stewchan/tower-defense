extends Node


func _ready():
	$MainMenu/M/VB/NewGame.connect("pressed",self, "on_new_game_pressed")
	$MainMenu/M/VB/Quit.connect("pressed",self,"on_quit_pressed")

func on_new_game_pressed():
	$MainMenu.queue_free()
	var game_scene = load("res://scenes/main_scenes/GameScene.tscn").instance()
	add_child(game_scene)
	
func on_quit_pressed():
	get_tree().quit()

