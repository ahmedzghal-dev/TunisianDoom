extends Node2D

#BackGround Music 
onready var MG3=get_node("Node/AudioStreamPlayer")
# Called when the node enters the scene tree for the first time.

func _ready():
	MG3.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
