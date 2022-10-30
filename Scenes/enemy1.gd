extends KinematicBody2D


const UP=Vector2(0,-1)
const GRAVITY=25
const MAXSPEED=50
const MAXGRAVITY=50


var movement=Vector2()


func _ready():
	pass


func _physics_process(delta):
	move_enemy()
	
func move_enemy():
	movement.y+=GRAVITY
	
	if(movement.y>MAXGRAVITY):
		movement.y=MAXGRAVITY
	
	if(is_on_floor()):
		movement.y=0
		
	movement.x=-MAXSPEED
	
	movement=move_and_slide(movement,UP)
