extends KinematicBody2D


enum ENEMYSTATE{IDEL,WALK,ATTACK,HURT,DEAD}
export (ENEMYSTATE) var currentState=ENEMYSTATE.WALK
export (ENEMYSTATE) var previouState=null

const UP=Vector2(0,-1)
const GRAVITY=25
const MAXSPEED=50
const MAXGRAVITY=50
const WeaponDamage=30

var EnemyLife=50
var is_hit=false

var movement=Vector2()
var moving_right=true
var player_in_range=false
var is_attacking= false

var dead=false

onready var AnimatedSprite: = $AnimatedSprite
onready var HitBox: = get_node("Area2D/HitBox")
onready var HealthUI: = get_node("healthbar")
onready var HealthBar: = get_node("healthbar/life")


func _ready():
	HealthBar.value=EnemyLife
	pass


func _physics_process(delta):
	
	player_in_range=false
	
	if(!$DownRay.is_colliding() || ($RightRay.is_colliding())):
		var collider=$RightRay.get_collider()
		if collider && collider.name=="player":
			movement=Vector2.ZERO
			player_in_range=true
		elif(is_on_floor()):
			player_in_range=false
			moving_right=!moving_right
			scale.x=-scale.x
			HealthUI.rect_scale.x=HealthUI.rect_scale.x
	
	executeState()
	move_enemy()
	
func attack():

	if player_in_range && AnimatedSprite.animation != "kick":
		AnimatedSprite.play("kick")
		is_attacking=true
	elif player_in_range && !AnimatedSprite.playing:
		is_attacking=false



func move_enemy():
	movement.y+=GRAVITY
	
	if(movement.y>MAXGRAVITY):
		movement.y=MAXGRAVITY
	
	if(is_on_floor()):
		movement.y=0
	
	
	
	
	movement=move_and_slide(movement,UP)
	
func executeState():
	
	match currentState:
		ENEMYSTATE.IDEL:
			if(AnimatedSprite.animation!="idel"):
				AnimatedSprite.play("idel")
			movement.x=0
			pass
			
		ENEMYSTATE.WALK:
			if(AnimatedSprite.animation!="walk"):
				AnimatedSprite.play("walk")
			movement.x=MAXSPEED if moving_right else -MAXSPEED
		
		ENEMYSTATE.ATTACK:
			attack()
			pass
			
		ENEMYSTATE.HURT:
			if(AnimatedSprite.animation!="hit"):
				AnimatedSprite.play("hit")
				movement.x=-76 if moving_right else 76
				movement.y=-50
			
			if(EnemyLife<=0):
				dead=true
			pass
		
		ENEMYSTATE.DEAD:
			if(AnimatedSprite.animation!="die"):
				AnimatedSprite.play("die")
				yield(AnimatedSprite, "animation_finished")
				queue_free()
			pass

	changeState()
	
	
	
	
	
	
	
	
func changeState():
	previouState=currentState
	
	match currentState:
		ENEMYSTATE.IDEL:
			if is_hit:
				currentState=ENEMYSTATE.HURT
			if !player_in_range:
				currentState=ENEMYSTATE.WALK
			pass
		
		ENEMYSTATE.WALK:
			if player_in_range:
				currentState=ENEMYSTATE.ATTACK
			if is_hit:
				currentState=ENEMYSTATE.HURT
			pass
		
		ENEMYSTATE.ATTACK:
			if  is_hit:
				currentState=ENEMYSTATE.HURT
			if !player_in_range:
				currentState=ENEMYSTATE.IDEL
			
			pass
		ENEMYSTATE.HURT:
			if !is_hit:
				currentState=ENEMYSTATE.IDEL
			if dead:
				currentState=ENEMYSTATE.DEAD
			pass
		
		ENEMYSTATE.DEAD:
			pass
	
	

func TakeDamage(damage):
	if !is_hit:
		EnemyLife-=damage
		HealthBar.value=EnemyLife
		is_hit=true
		AnimatedSprite.play("hit")


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
