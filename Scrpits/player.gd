extends KinematicBody2D

signal PlayerHealthChange

enum PLAYERSTATE{IDEL,RUN,JUMP,ATTACK,HURT,DEAD}
export (PLAYERSTATE) var currentState=PLAYERSTATE.IDEL
export (PLAYERSTATE) var previousState=null

#movment 
const UP = Vector2(0,-1)
const GRAVITY = 70
const MAXSPEED = 90
const MAXGRAVITY = 150
const JUMPSPEED = 800

var PlayerLife = 100
var is_hit = false
var is_attacking=false
var WeaponDamage = 20

var score = 0

var left
var right
var jump
var attack
var dead=false
var moving_right=true

onready var AnimatedSprite: = $AnimatedSprite
onready var HitBox: = get_node("Area2D/HitBox")
onready var labelState:=get_node("Label")
onready var KickAttack:=get_node("KickSwoosh")
onready var PlayerHit:=get_node("PlayerHit")
onready var PlayerWalk:=get_node("PlayerWalk")
onready var PlayerDie:=get_node("PlayerDie")


var movment = Vector2()

func _ready():
	emit_signal("PlayerHealthChange", PlayerLife)
	set_process(true)
	pass
	
func _process(delta):
	var LabelNode = get_parent().get_node("score counter/UI/Control/RichTextLabel")
	LabelNode.text = str(score)
	pass
# player movment
func _physics_process(delta):
	HandleInput()
	executeState()
	
	movment.y+=GRAVITY

	if movment.y> MAXGRAVITY:
		movment.y=MAXGRAVITY
		
	movment=move_and_slide(movment,UP)
	
#finit state machine methode
func executeState():
	
	match currentState:
		PLAYERSTATE.IDEL:
			labelState.text="IDEL"
			AnimatedSprite.play("Idel")
			movment.x=0
			pass
		PLAYERSTATE.RUN:
			labelState.text="RUN"
			if left:
				movment.x=-MAXSPEED
				AnimatedSprite.set_flip_h(true)
			if right:
				movment.x=MAXSPEED
				AnimatedSprite.set_flip_h(false)
			if(AnimatedSprite.animation!="Run"):
				AnimatedSprite.play("Run")
				PlayerWalk.play()
			pass
		PLAYERSTATE.JUMP:
			labelState.text="JUMP"
			AnimatedSprite.play("Jump")
			if(is_on_floor()):
				movment.y=-JUMPSPEED
			pass
		PLAYERSTATE.ATTACK:
			labelState.text="ATTACK"
			Attack()
			pass
		PLAYERSTATE.HURT:
			labelState.text="HURT"
			if(AnimatedSprite.animation!="Hit"):
				AnimatedSprite.play("Hit")
				PlayerHit.play()
				movment.x=-76 if moving_right else 76
				movment.y=-150
		
			if(PlayerLife<=0):
				dead=true
			movment.x=-0
			movment.y=-0
			pass
		PLAYERSTATE.DEAD:
			if(AnimatedSprite.animation!="Die"):
				AnimatedSprite.play("Die")
				PlayerDie.play()
				yield(AnimatedSprite, "animation_finished")
				queue_free()
				get_tree().reload_current_scene()
				#set_physics_process(false)
				#visible=false
			pass
	changeState()
	
func changeState():
	previousState=currentState
	
	match currentState:
		PLAYERSTATE.IDEL:
			if(left || right):
				currentState=PLAYERSTATE.RUN
			if attack:
				currentState=PLAYERSTATE.ATTACK
			if jump:
				currentState=PLAYERSTATE.JUMP
			if is_hit:
				currentState=PLAYERSTATE.HURT
			pass
		PLAYERSTATE.RUN:
			if !(left || right):
				currentState=PLAYERSTATE.IDEL
			if attack:
				currentState=PLAYERSTATE.ATTACK
			if jump:
				currentState=PLAYERSTATE.JUMP
			if is_hit:
				currentState=PLAYERSTATE.HURT
			pass
		PLAYERSTATE.JUMP:
			if(is_on_floor()):
				currentState=PLAYERSTATE.IDEL
			if is_hit:
				currentState=PLAYERSTATE.HURT
			pass
		PLAYERSTATE.ATTACK:
			if(!is_attacking):
				currentState=PLAYERSTATE.IDEL
				HitBox.disabled=true
			pass
		PLAYERSTATE.HURT:
			if !is_hit:
				currentState=PLAYERSTATE.IDEL
			if dead:
				currentState=PLAYERSTATE.DEAD
			pass
		PLAYERSTATE.DEAD:
			pass
			
# key's inputs
func HandleInput():
	left = Input.is_action_pressed("left")
	right = Input.is_action_pressed("right")
	jump = Input.is_action_just_pressed("jump")
	attack = Input.is_action_pressed("attack")
	
# player attack	
func Attack():
	if !is_attacking && AnimatedSprite.animation != "Kick":
		HitBox.disabled=false
		AnimatedSprite.play("Kick")
		KickAttack.play()
		is_attacking=true
		if(left):
			movment.x=-50
			AnimatedSprite.set_flip_h(true)
		if(right):
			movment.x=50
			AnimatedSprite.set_flip_h(false)
#player taking damage
func TakeDamage(damage):
	if !is_hit:
		PlayerLife-=damage
		emit_signal("PlayerHealthChange", PlayerLife)
		is_hit=true
		



func _on_AnimatedSprite_animation_finished():
	if is_hit && AnimatedSprite.animation=="Hit":
		is_hit=false

	if AnimatedSprite.animation=="Kick":
		is_attacking=false


func _on_Area2D_body_entered(body):
	if body.has_method("TakeDamage"):
		body.TakeDamage(WeaponDamage)






func _on_coin_0_body_entered(body):
	score += 1
	pass # Replace with function body.
