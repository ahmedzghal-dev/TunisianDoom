extends Area2D

#collectables
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idel")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_coin_0_body_entered(body):
	queue_free()
	pass # Replace with function body.
