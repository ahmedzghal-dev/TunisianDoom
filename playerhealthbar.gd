extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func _process(delta):
#	pass


func _on_player_PlayerHealthChange(var life):
	value=life
	pass # Replace with function body.
