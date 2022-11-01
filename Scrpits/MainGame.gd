extends Node2D

#background MusicGame
onready var MusicGame:=get_node("MusicGame")

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicGame.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	pass
