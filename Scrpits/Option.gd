extends Control

#key building option interface
onready var OM=get_node("CanvasLayer/AudioStreamPlayer")

func _ready():
	OM.play()
	$VBoxContainer/BacktoMenu.grab_focus()

func _on_BacktoMenu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
