extends Node2D


var movment=Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	$AnimatedSprite.play("fly")
	movment=Vector2.ZERO
