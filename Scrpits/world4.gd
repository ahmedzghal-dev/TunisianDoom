extends Node2D


onready var MG4=get_node("Node/AudioStreamPlayer")

# Called when the node enters the scene tree for the first time.
#background music level
func _ready():
	MG4.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame
#func _process(delta):
#	pass
