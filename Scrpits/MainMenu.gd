extends Control

# UI User interface
onready var MMG=get_node("CanvasLayer/AudioStreamPlayer")
# Called when the node enters the scene tree for the first time.
func _ready():
	MMG.play()
	$VBoxContainer/StartButton.grab_focus()




func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/world.tscn")




func _on_OptionButton_pressed():
	get_tree().change_scene("res://Scenes/Option.tscn")





func _on_ExitButton_pressed():
	get_tree().quit()
