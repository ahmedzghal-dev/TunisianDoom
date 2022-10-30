extends KinematicBody2D


const UP=Vector2(0,-1)
const GRAVITY=25
const MAXSPEED=50
const MAXGRAVITY=50
const WeaponDamage=10

var EnemyLife=50
var is_hit=false

var movement=Vector2()
var moving_right=true
var player_in_range=false
var is_attacking= false

onready var AnimatedSprite: = $AnimatedSprite
onready var HitBox: = $Area2D/HitBox

func _ready():
	pass


func _physics_process(delta):
#checking where the collider interact with the ground or the player
	if(!$DownRay.is_colliding() || ($RightRay.is_colliding())):
		var collider=$RightRay.get_collider()
		if collider && collider.name=="player":
			movement=Vector2.ZERO
			player_in_range=true
		else:
			moving_right=!moving_right
			scale.x=-scale.x
	
	attack()
	animate()
	move_enemy()

#attack function
func attack():
	if is_hit:
		return
	if player_in_range && AnimatedSprite.animation != "kick":
		AnimatedSprite.play("kick")
		is_attacking=true
	elif player_in_range && !AnimatedSprite.playing:
		is_attacking=false

func animate():
	if is_attacking:
		return
	if movement!=Vector2.ZERO:
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idel")

#enemy movement
func move_enemy():
	movement.y+=GRAVITY
	
	if(movement.y>MAXGRAVITY):
		movement.y=MAXGRAVITY
	
	if(is_on_floor()):
		movement.y=0
	
	
	if !player_in_range:
		movement.x=MAXSPEED if moving_right else -MAXSPEED
	
	movement=move_and_slide(movement,UP)


#damage function
func TakeDamage(damage):
	if !is_hit:
		EnemyLife=-damage
		is_hit=true
		$AnimatedSprite.play("hit")
		print("ENEMY TAKING DAMAGE")
		print(EnemyLife)
	if(EnemyLife<=0):
		AnimatedSprite.play("die")


func _on_AnimatedSprite_frame_changed():
	if AnimatedSprite.animation=="kick" && AnimatedSprite.frame >= 7 && AnimatedSprite.frame <=8:
		HitBox.disabled=false
	else:
		HitBox.disabled=true



func _on_Area2D_body_entered(body):
	if body.has_method("TakeDamage"):
		body.TakeDamage(WeaponDamage)


func _on_AnimatedSprite_animation_finished():
	if is_hit && AnimatedSprite.animation=="hit":
		is_hit=false
		AnimatedSprite.play("idel")
