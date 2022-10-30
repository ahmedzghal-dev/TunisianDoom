extends Node2D


onready var MG = get_node("MusicGame2/AudioStreamPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	MG.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
